//
//  File.swift
//  
//
//  Created by Abhijana Agung Ramanda on 15/01/21.
//

import Foundation
import Core
import Combine
import Alamofire

public class AutocompleteRemoteDataSource: RemoteDataSource {
  public typealias Request = String
  public typealias Response = (Float, [AutocompleteResponse])
  
  public static let shared: (NetworkClient) -> AutocompleteRemoteDataSource = {
    AutocompleteRemoteDataSource(networkClient: $0)
  }
  
  private let networkClient: NetworkClient
  
  private init(networkClient: NetworkClient) {
    self.networkClient = networkClient
  }
  
  public func execute(request: String) -> AnyPublisher<(Float, [AutocompleteResponse]), Error> {
    Future<(Float, [AutocompleteResponse]), Error> { [unowned self] promise in
      self.networkClient.request(SpoonacularRouter.autocomplete(request))
        .responseDecodable(of: [AutocompleteResponse].self) { response in
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
    }
    .eraseToAnyPublisher()
  }
}

