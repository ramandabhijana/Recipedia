//
//  File.swift
//  
//
//  Created by Abhijana Agung Ramanda on 14/01/21.
//

import Core
import Combine
import Recipe
import RealmSwift

public class GetRecipeLocaleDataSource: LocaleDataSource {
  public typealias Request = Any
  public typealias Response = RecipeModuleEntity
  
  private let realm: Realm?
  
  public static let shared: (Realm?) -> GetRecipeLocaleDataSource = {
    GetRecipeLocaleDataSource(realm: $0)
  }
  
  private init(realm: Realm?) {
    self.realm = realm
  }
  
  public func getList(request: Any? = nil) -> AnyPublisher<[RecipeModuleEntity], Error> {
    Future<[RecipeModuleEntity], Error> { completion in
      guard let realm = self.realm else {
        completion(.failure(DatabaseError.invalidInstance))
        return
      }
      let recipes: Results<RecipeModuleEntity> = {
        realm.objects(RecipeModuleEntity.self)
      }()
      completion(
        .success(recipes.toArray(ofType: RecipeModuleEntity.self))
      )
    }
    .eraseToAnyPublisher()
  }
  
  public func addEntity(_ entity: RecipeModuleEntity) -> AnyPublisher<Bool, Error> {
    Future<Bool, Error> { completion in
      guard let realm = self.realm else {
        completion(.failure(DatabaseError.invalidInstance))
        return
      }
      do {
        try realm.write {
          realm.add(entity)
          completion(.success(true))
        }
      } catch {
        completion(.failure(DatabaseError.requestFailed))
      }
    }
    .eraseToAnyPublisher()
  }
  
  public func deleteEntity(byId entityId: Int) -> AnyPublisher<Bool, Error> {
    Future<Bool, Error> { completion in
      guard
        let realm = self.realm,
        let object = realm.object(
          ofType: RecipeModuleEntity.self,
          forPrimaryKey: entityId
        )
      else {
        completion(.failure(DatabaseError.invalidInstance))
        return
      }
      do {
        try realm.write {
          realm.delete(object, cascading: true)
          completion(.success(true))
        }
      } catch {
        completion(.failure(DatabaseError.requestFailed))
      }
    }
    .eraseToAnyPublisher()
  }
  
  public func checkExistence(of entity: RecipeModuleEntity) -> AnyPublisher<Bool, Error> {
    getList()
      .flatMap { entities -> AnyPublisher<Bool, Never> in
        entities.publisher
          .contains(entity)
          .eraseToAnyPublisher()
      }
      .mapError { $0 }
      .eraseToAnyPublisher()
  }
}


