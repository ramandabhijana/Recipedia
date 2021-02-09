//
//  Injection.swift
//  Recipedia
//
//  Created by Abhijana Agung Ramanda on 01/02/21.
//

import Foundation
import RealmSwift
import Alamofire
import Core
import Recipe
import UIKit
import RecipeDetail
import AutocompleteSearch
import ImageClassification

final class Injection: NSObject {
  
  private var appDelegate: AppDelegate {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
    else { fatalError("Cannot retrieve app delegate instance") }
    return appDelegate
  }
  
  func provideReachability() -> NetworkReachability {
    NetworkReachability.shared(NetworkReachabilityManager())
  }
  
  func provideNetworkClient() -> NetworkClient {
    NetworkClient.shared(.default)
  }
  
  func provideRecipesRepository() -> RecipesRepository {
    let locale = GetRecipesLocaleDataSource.shared(appDelegate.realm)
    let remote = GetRecipesRemoteDataSource.shared(provideNetworkClient())
    let mapper = RecipesMapper.shared
    return GetRecipesRepository(
      localDataSource: locale,
      remoteDataSource: remote,
      mapper: mapper
    )
  }
  
  func provideDetailRecipe<U: UseCase>(model: U.Response) -> U?
  where
    U.Request == Int,
    U.Response == RecipeDomainModel {
    let locale = GetRecipeLocaleDataSource.shared(appDelegate.realm)
    let remote = GetRecipeRemoteDataSource.shared(provideNetworkClient())
    let mapper = RecipeMapper.shared
    let repository = GetRecipeRepository(
      localDataSource: locale,
      remoteDataSource: remote,
      mapper: mapper
    )
    return DetailInteractor(repository: repository, recipe: model) as? U
  }
  
  func provideRemoteRecipes<U: RemoteUseCase>() -> U?
  where
    U.Request == RecipeListParameter,
    U.Response == [RecipeDomainModel] {
    let repository = provideRecipesRepository()
    return RemoteInteractor(
      repository: repository,
      reachability: provideReachability()
    ) as? U
  }
  
  func provideLocaleRecipes<U: UseCase>() -> U?
  where
    U.Request == RecipeListParameter,
    U.Response == [RecipeDomainModel] {
    let repository = provideRecipesRepository()
    return ReactiveResponseInteractor(repository: repository) as? U
  }
  
  func provideAutocompleteSearch<U: UseCase>() -> U?
  where
    U.Request == String,
    U.Response == [AutocompleteDomainModel] {
    let remoteDataSource = AutocompleteRemoteDataSource.shared(provideNetworkClient())
    let mapper = AutocompleteMapper()
    let repository = AutocompleteRepository(
      remoteDataSource: remoteDataSource,
      mapper: mapper
    )
    return Interactor(repository: repository) as? U
  }
  
  func provideClassification<U: UseCase>() -> U?
  where
    U.Request == Data,
    U.Response == ClassificationDomainModel {
    let remoteDataSource = ClassificationRemoteDataSource.shared(provideNetworkClient())
    let mapper = ClassificationMapper()
    let repository = ClassificationRepository(
      remoteDataSource: remoteDataSource,
      mapper: mapper
    )
    return Interactor(repository: repository) as? U
  }
  
}
