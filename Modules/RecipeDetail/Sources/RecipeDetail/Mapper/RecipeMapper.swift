//
//  File.swift
//  
//
//  Created by Abhijana Agung Ramanda on 14/01/21.
//

import Core
import Recipe

public struct RecipeMapper: Mapper, RecipeConvertable {
  public func mapResponseToDomain(_ response: RecipeResponse) -> RecipeDomainModel {
    convertToModel(from: response)
  }
  
  public func mapEntityToDomain(_ entity: RecipeModuleEntity) -> RecipeDomainModel {
    convertToModel(from: entity)
  }
  
  public func mapDomainToEntity(_ domain: RecipeDomainModel) -> RecipeModuleEntity {
    convertToEntity(from: domain)
  }
  
  public typealias Response = RecipeResponse
  public typealias Entity = RecipeModuleEntity
  public typealias Domain = RecipeDomainModel
  
  public static let shared = RecipeMapper()
  
  private init() { }
}
