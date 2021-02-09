//
//  File.swift
//  
//
//  Created by Abhijana Agung Ramanda on 23/01/21.
//

import Foundation
import Combine
import Core
import RealmSwift

public protocol ReactiveResponseUseCase: UseCase {
  var latestResponse: AnyPublisher<Response, Never> { get }
}

public class ReactiveResponseInteractor<Request, Response, R: RecipesRepositoryProtocol>: ReactiveResponseUseCase
where
  R.Request == Request,
  R.Response == Response {
  
  private var repository: R
  
  public var latestResponse: AnyPublisher<Response, Never> {
    self.repository.getLatestLocaleRecipes()
  }
  
  public init(repository: R) {
    self.repository = repository
  }
  
  public func execute(request: Request) -> AnyPublisher<Response, Error> {
    return repository.execute(request: request)
  }
}
