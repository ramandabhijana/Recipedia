//
//  File.swift
//  
//
//  Created by Abhijana Agung Ramanda on 26/01/21.
//

import Foundation
import Core

public typealias RemoteRecipesUseCase = RemoteInteractor<
  RecipeListParameter,
  [RecipeDomainModel],
  GetRecipesRepository<
    GetRecipesLocaleDataSource,
    GetRecipesRemoteDataSource,
    RecipesMapper
  >
>

public typealias HomePresenter = RemoteListPresenter<
  RecipeListParameter,
  RecipeDomainModel,
  RemoteRecipesUseCase
>

public typealias LocaleRecipesUseCase = ReactiveResponseInteractor<
  RecipeListParameter,
  [RecipeDomainModel],
  GetRecipesRepository<
    GetRecipesLocaleDataSource,
    GetRecipesRemoteDataSource,
    RecipesMapper
  >
>

public typealias FavoritePresenter = LocaleListPresenter<
  RecipeListParameter,
  RecipeDomainModel,
  LocaleRecipesUseCase
>

public typealias RecipesRepository = GetRecipesRepository<
  GetRecipesLocaleDataSource,
  GetRecipesRemoteDataSource,
  RecipesMapper
>
