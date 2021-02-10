//
//  SceneDelegate.swift
//  Recipedia
//
//  Created by Abhijana Agung Ramanda on 01/02/21.
//

import SwiftUI
import Core
import Alamofire
import Recipe
import RecipeDetail
import AutocompleteSearch
import ImageClassification
import RealmSwift
import Swinject
import SwinjectAutoregistration

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  
  private var realm: Realm?
  
  internal lazy var container: Container = {
    let container = Container()
    
    container.autoregister(
      NetworkClient.self,
      argument: Session.self,
      initializer: NetworkClient.shared
    )
    
    container.register(NetworkReachability.self) { _ in
      .shared(.default)
    }
    
    container.register(RecipesRepository.self) { [weak self] resolver in
      let client = resolver ~> (NetworkClient.self, argument: Session.default)
      let locale = GetRecipesLocaleDataSource.shared(self?.realm)
      let remote = GetRecipesRemoteDataSource.shared(client)
      let mapper = RecipesMapper.shared
      return GetRecipesRepository(
        localDataSource: locale,
        remoteDataSource: remote,
        mapper: mapper
      )
    }
    
    container.register(RecipeRepository.self) { [weak self] resolver in
      let client = resolver ~> (NetworkClient.self, argument: Session.default)
      let locale = GetRecipeLocaleDataSource.shared(self?.realm)
      let remote = GetRecipeRemoteDataSource.shared(client)
      let mapper = RecipeMapper.shared
      return GetRecipeRepository(
        localDataSource: locale,
        remoteDataSource: remote,
        mapper: mapper
      )
    }
    
    container.register(RemoteRecipesUseCase.self) { resolver in
      let reachability = resolver.resolve(NetworkReachability.self)!
      let repository = resolver.resolve(RecipesRepository.self)!
      return RemoteInteractor(
        repository: repository,
        reachability: reachability
      )
    }
    
    container.register(LocaleRecipesUseCase.self) { resolver in
      let repository = resolver.resolve(RecipesRepository.self)!
      return ReactiveResponseInteractor(repository: repository)
    }
    
    container.autoregister(
      GetDetailUseCase.self,
      argument: GetDetailUseCase.Response.self,
      initializer: DetailInteractor.init(repository:recipe:)
    )
    
    container.register(AutocompleteUseCase.self) { resolver in
      let client = resolver ~> (NetworkClient.self, argument: Session.default)
      let remoteDataSource = AutocompleteRemoteDataSource.shared(client)
      let mapper = AutocompleteMapper()
      let repository = AutocompleteRepository(
        remoteDataSource: remoteDataSource,
        mapper: mapper
      )
      return Interactor(repository: repository)
    }
    
    container.register(ClassificationUseCase.self) { resolver in
      let client = resolver ~> (NetworkClient.self, argument: Session.default)
      let remoteDataSource = ClassificationRemoteDataSource.shared(client)
      let mapper = ClassificationMapper()
      let repository = ClassificationRepository(
        remoteDataSource: remoteDataSource,
        mapper: mapper
      )
      return Interactor(repository: repository)
    }
    
    return container
  }()
  
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    realm = try? Realm()
    
    let homePresenter = RemoteListPresenter(
      useCase: container ~> (RemoteRecipesUseCase.self),
      request: .name("Beef")
    )
    let favoritePresenter = LocaleListPresenter(
      useCase: container ~> (LocaleRecipesUseCase.self),
      request: .local
    )
    let autocompletePresenter = GetAutocompletePresenter(
      useCase: container ~> (AutocompleteUseCase.self)
    )
    
    let contentView = ContentView()
      .environmentObject(homePresenter)
      .environmentObject(favoritePresenter)
      .environmentObject(autocompletePresenter)
    
    if let windowScene = scene as? UIWindowScene {
      let window = UIWindow(windowScene: windowScene)
      window.rootViewController = UIHostingController(rootView: contentView)
      self.window = window
      window.makeKeyAndVisible()
    }
  }

}
