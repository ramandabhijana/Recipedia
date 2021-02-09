//
//  File.swift
//  
//
//  Created by Abhijana Agung Ramanda on 26/01/21.
//

import Foundation
import struct Recipe.RecipeDomainModel

public typealias GetDetailUseCase = DetailInteractor<
  Int,
  RecipeDomainModel,
  GetRecipeRepository<
    GetRecipeLocaleDataSource,
    GetRecipeRemoteDataSource,
    RecipeMapper
  >
>

public typealias GetDetailPresenter = DetailPresenter<
  Int,
  RecipeDomainModel,
  GetDetailUseCase
>

public typealias GetInstructionMiscPresenter = InstructionMiscPresenter<
  InstructionMiscDataSourceType,
  InstructionMisc,
  InstructionMiscInteractor
>
