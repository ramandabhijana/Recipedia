//
//  GetRecipesLocalDataSource.swift
//  
//
//  Created by Abhijana Agung Ramanda on 01/01/21.
//

import Foundation
import Core
import Combine
import RealmSwift

@objc public protocol DynamicDataSource {
  @objc dynamic var response: Any { get set }
}

public protocol LocaleObjectsDataSource: DataSource,
                                         DynamicDataSource { }

public class GetRecipesLocaleDataSource: NSObject, LocaleObjectsDataSource {
  
  public typealias Request = Any
  public typealias Response = [RecipeModuleEntity]
  
  private let realm: Realm?
  private var notificationToken: NotificationToken?
  private static let responseElementType = Response.Element.self
  
  @objc dynamic public var response: Any = []
  
  public static let shared: (Realm?) -> GetRecipesLocaleDataSource = {
    GetRecipesLocaleDataSource(realm: $0)
  }
  
  private init(realm: Realm?) {
    self.realm = realm
    super.init()
    self.notificationToken = realm?
      .objects(Self.responseElementType)
      .observe { [weak self] changes in
        switch changes {
        case .initial(let results),
             .update(let results, deletions: _, insertions: _, modifications: _):
          let response = results.toArray(ofType: Self.responseElementType)
          self?.response = response
        default:
          break
        }
      }
  }
  
  deinit {
    notificationToken?.invalidate()
  }
  
  public func execute(request: Any?) -> AnyPublisher<[RecipeModuleEntity], Error> {
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
  
}


