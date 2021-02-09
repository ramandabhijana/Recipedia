//
//  File.swift
//  
//
//  Created by Abhijana Agung Ramanda on 14/01/21.
//

import Core
import Combine
import Foundation
import Recipe

public protocol RecipeRepository: Repository {
  func addEntity(_ entity: Response) -> AnyPublisher<Bool, Error>
  func deleteEntity(byId entityId: Request) -> AnyPublisher<Bool, Error>
  func checkExistence(of entity: Response) -> AnyPublisher<Bool, Error>
}

public class GetRecipeRepository<
  Local: LocaleDataSource,
  Remote: RemoteDataSource,
  Transformer: Mapper
>: RecipeRepository
where
  Local.Request == Any,
  Remote.Request == Int,
  Local.Response == RecipeModuleEntity,
  Remote.Response == (Float, RecipeResponse),
  Transformer.Response == RecipeResponse,
  Transformer.Entity == RecipeModuleEntity,
  Transformer.Domain == RecipeDomainModel {
  
  public typealias Request = Int
  public typealias Response = RecipeDomainModel
  
  private let localDataSource: Local
  private var remoteDataSource: Remote
  private let mapper: Transformer
  
  public init(
    localDataSource: Local,
    remoteDataSource: Remote,
    mapper: Transformer
  ) {
    self.localDataSource = localDataSource
    self.remoteDataSource = remoteDataSource
    self.mapper = mapper
  }
  
  public func execute(request: Int) -> AnyPublisher<RecipeDomainModel, Error> {
    remoteDataSource.execute(request: request)
      .map { [unowned self] response in
        let model = self.mapper.mapResponseToDomain(response.1)
        QuotaManager.shared.set(response.0)
        return model
      }
      .eraseToAnyPublisher()
  }
  
  public func addEntity(_ entity: RecipeDomainModel) -> AnyPublisher<Bool, Error> {
    let recipeEntity = mapper.mapDomainToEntity(entity)
    return localDataSource.addEntity(recipeEntity)
  }
  
  public func deleteEntity(byId entityId: Int) -> AnyPublisher<Bool, Error> {
    localDataSource.deleteEntity(byId: entityId)
  }
  
  public func checkExistence(of entity: RecipeDomainModel) -> AnyPublisher<Bool, Error> {
    let recipeEntity = mapper.mapDomainToEntity(entity)
    return localDataSource.checkExistence(of: recipeEntity)
  }
}
