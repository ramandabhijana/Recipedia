//
//  File.swift
//  
//
//  Created by Abhijana Agung Ramanda on 14/01/21.
//

import Core
import Combine
import Alamofire
import Foundation
import Recipe

public class GetRecipeRemoteDataSource: RemoteDataSource {
  public typealias Request = Int
  public typealias Response = (Float, RecipeResponse)
  
  public static let shared: (NetworkClient) -> GetRecipeRemoteDataSource = {
    GetRecipeRemoteDataSource(networkClient: $0)
  }
  
  private let networkClient: NetworkClient
  
  private init(networkClient: NetworkClient) {
    self.networkClient = networkClient
  }
  
  public func execute(request: Int) -> AnyPublisher<(Float, RecipeResponse), Error> {
    Future<(Float, RecipeResponse), Error> { [unowned self] promise in
      self.networkClient.request(SpoonacularRouter.detail("\(request)"))
        .responseDecodable(of: RecipeResponse.self) { response in
          switch response.result {
          case .success(let value):
            if
              let aHeader = response.response?.allHeaderFields["x-api-quota-used"]
                as? String,
              let quotaUsed = Float(aHeader) {
              promise(
                .success( (quotaUsed, value) )
              )
            }
          case .failure(let error):
            promise(.failure(error))
          }
        }
    }.eraseToAnyPublisher()
    
  }
}
