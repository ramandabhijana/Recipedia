//
//  GetRecipesRemoteDataSource.swift
//  
//
//  Created by Abhijana Agung Ramanda on 01/01/21.
//

import Core
import Combine
import Alamofire
import Foundation

public class GetRecipesRemoteDataSource: RemoteDataSource {
  public typealias Request = String
  public typealias Response = (Float, [RecipeResponse])
  
  public static let shared: (NetworkClient) -> GetRecipesRemoteDataSource = {
    GetRecipesRemoteDataSource(networkClient: $0)
  }
  
  private var offset = 0
  private let networkClient: NetworkClient
  private var previousRequest: Request?
  
  private init(networkClient: NetworkClient) {
    self.networkClient = networkClient
  }
  
  public func execute(request: String) -> AnyPublisher<
    (Float, [RecipeResponse]),
    Error
  > {
    return Future<(Float, [RecipeResponse]), Error> { [weak self] promise in
      guard let self = self else { return }
      if let previousRequest = self.previousRequest,
         previousRequest != request {
        self.offset = 0
      }
      self.previousRequest = request
      self.networkClient.request(
        SpoonacularRouter.listByName(request, offset: self.offset)
      )
        .responseDecodable(of: RecipesResponse.self) { [weak self] response in
          switch response.result {
          case .success(let value):
            if
              let aHeader = response.response?.allHeaderFields["x-api-quota-used"]
                as? String,
              let quotaUsed = Float(aHeader) {
              self?.offset += 10
              promise(
                .success( (quotaUsed, value.results) )
              )
            }
          case .failure(let error):
            promise(.failure(error))
          }
        }
      
    }.eraseToAnyPublisher()
  }
  
}
