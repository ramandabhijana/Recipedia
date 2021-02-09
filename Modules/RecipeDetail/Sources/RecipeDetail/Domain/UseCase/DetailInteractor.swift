//
//  File.swift
//  
//
//  Created by Abhijana Agung Ramanda on 14/01/21.
//

import Combine
import Core

public protocol DetailUseCase: UseCase {
  func getRecipe() -> Response
  func addEntity(_ entity: Response) -> AnyPublisher<Bool, Error>
  func deleteEntity(byId entityId: Request) -> AnyPublisher<Bool, Error>
  func checkExistence(of entity: Response) -> AnyPublisher<Bool, Error>
}

public class DetailInteractor<Request, Response, R: RecipeRepository>: DetailUseCase
where
  R.Request == Request,
  R.Response == Response {
  
  private var repository: R
  private let recipe: Response
  
  public init(repository: R, recipe: Response) {
    self.repository = repository
    self.recipe = recipe
  }
  
  public func execute(request: Request) -> AnyPublisher<Response, Error> {
    repository.execute(request: request)
  }
  
  public func getRecipe() -> Response { recipe }
  
  public func addEntity(_ entity: Response) -> AnyPublisher<Bool, Error> {
    repository.addEntity(entity)
  }
  
  public func deleteEntity(byId entityId: Request) -> AnyPublisher<Bool, Error> {
    repository.deleteEntity(byId: entityId)
  }
  
  public func checkExistence(of entity: Response) -> AnyPublisher<Bool, Error> {
    repository.checkExistence(of: entity)
  }
}
