//
//  GetRecipesRepository.swift
//  
//
//  Created by Abhijana Agung Ramanda on 01/01/21.
//

import Core
import Combine
import Foundation
import RealmSwift

public protocol RecipesRepositoryProtocol: Repository {
  func getLatestLocaleRecipes() -> AnyPublisher<Response, Never>
}

public class GetRecipesRepository<
  Local: LocaleObjectsDataSource & NSObject,
  Remote: RemoteDataSource,
  Transformer: Mapper
>: RecipesRepositoryProtocol
where
  Local.Request == Any,
  Remote.Request == String,
  Local.Response == [RecipeModuleEntity],
  Remote.Response == (Float, [RecipeResponse]),
  Transformer.Response == [RecipeResponse],
  Transformer.Entity == [RecipeModuleEntity],
  Transformer.Domain == [RecipeDomainModel]
{

  public typealias Request = RecipeListParameter
  public typealias Response = [RecipeDomainModel]
  
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
  
  public func execute(request: RecipeListParameter) -> AnyPublisher<[RecipeDomainModel], Error> {
    switch request {
    case .local:
      return getFavoriteRecipes()
    case .name(let name):
      return getRecipes(by: name)
    }
  }
  
  public func getLatestLocaleRecipes() -> AnyPublisher<[RecipeDomainModel], Never> {
    return localDataSource
      .publisher(for: \.response)
      .map{ [unowned self] response -> Response? in
        guard let entities = response as? Local.Response
        else { return nil }
        let models = self.mapper.mapEntityToDomain(entities)
        return models
      }
      .compactMap { $0 }
      .eraseToAnyPublisher()
  }
  
  private func getRecipes(by name: String) -> AnyPublisher<[RecipeDomainModel], Error> {
    remoteDataSource.execute(request: name)
      .map { [unowned self] response -> [RecipeDomainModel] in
        let models = self.mapper.mapResponseToDomain(response.1)
        QuotaManager.shared.set(response.0)
        print(response.0)
        return models
      }
      .eraseToAnyPublisher()
  }
  
  private func getFavoriteRecipes() -> AnyPublisher<[RecipeDomainModel], Error> {
    localDataSource.execute(request: nil)
      .map { [unowned self] in
        let models = self.mapper.mapEntityToDomain($0)
        return models
      }
      .eraseToAnyPublisher()
  }
  
}


