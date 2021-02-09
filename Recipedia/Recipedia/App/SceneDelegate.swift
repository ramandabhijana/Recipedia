//
//  SceneDelegate.swift
//  Recipedia
//
//  Created by Abhijana Agung Ramanda on 01/02/21.
//

import UIKit
import SwiftUI
import Core
import Recipe
import RecipeDetail
import AutocompleteSearch
import ImageClassification

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    let homePresenter: HomePresenter = {
      guard let useCase: RemoteRecipesUseCase = Injection().provideRemoteRecipes()
      else { fatalError(useCaseErrorMessage) }
      return RemoteListPresenter(
        useCase: useCase,
        request: .name("Beef")
      )
    }()
    
    let favoritePresenter: FavoritePresenter = {
      guard let useCase: LocaleRecipesUseCase = Injection().provideLocaleRecipes()
      else { fatalError(useCaseErrorMessage) }
      return LocaleListPresenter(
        useCase: useCase,
        request: .local
      )
    }()
    
    let autocompletePresenter: GetAutocompletePresenter = {
      guard let useCase: AutocompleteUseCase = Injection().provideAutocompleteSearch()
      else { fatalError(useCaseErrorMessage) }
      return GetAutocompletePresenter(useCase: useCase)
    }()
    
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
