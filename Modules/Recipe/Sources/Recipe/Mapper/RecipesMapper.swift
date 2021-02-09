//
//  RecipeMapper.swift
//  
//
//  Created by Abhijana Agung Ramanda on 02/01/21.
//

import Core

public class RecipesMapper: Mapper, RecipeConvertable {
  public func mapEntityToDomain(_ entity: [RecipeModuleEntity]) -> [RecipeDomainModel] {
    entity.map { convertToModel(from: $0) }
  }
  
  public func mapDomainToEntity(_ domain: [RecipeDomainModel]) -> [RecipeModuleEntity] {
    domain.map { convertToEntity(from: $0) }
  }
  
  public func mapResponseToDomain(_ response:  [RecipeResponse]) -> [RecipeDomainModel] {
    response.map { convertToModel(from: $0) }
  }
  
  public typealias Response = [RecipeResponse]
  public typealias Entity = [RecipeModuleEntity]
  public typealias Domain = [RecipeDomainModel]
  
  public static let shared = RecipesMapper()
  
  private init() { }
}
