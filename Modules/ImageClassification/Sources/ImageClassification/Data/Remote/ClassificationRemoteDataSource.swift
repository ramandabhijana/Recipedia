//
//  File.swift
//  
//
//  Created by Abhijana Agung Ramanda on 16/01/21.
//

import Foundation
import Core
import Combine
import Alamofire

public class ClassificationRemoteDataSource: RemoteDataSource {
  public typealias Request = Data
  public typealias Response = (Float, ClassificationResponse)
  
  public static let shared: (NetworkClient) -> ClassificationRemoteDataSource = {
    ClassificationRemoteDataSource(networkClient: $0)
  }
  
  private let networkClient: NetworkClient
  
  private init(networkClient: NetworkClient) {
    self.networkClient = networkClient
  }
  
  public func execute(request: Data) -> AnyPublisher<
    (Float, ClassificationResponse),
    Error
  > {
    Future<(Float, ClassificationResponse), Error> { [unowned self] promise in
      networkClient.upload(multipartFormData: { multipartFormData in
        multipartFormData.append(
          request,
          withName: "file",
          fileName: "food.png",
          mimeType: "image/png"
        )
      },
      to: SpoonacularRouter.classify
      )
      .uploadProgress(queue: .main, closure: { progress in
        print("Upload Progress: \(progress.fractionCompleted)")
      })
      .responseDecodable(of: ClassificationResponse.self) { response in
        switch response.result {
        case .success(let value):
          print(value)
          if
            let aHeader = response.response?.allHeaderFields["x-api-quota-used"]
              as? String,
            let quotaUsed = Float(aHeader) {
            promise(
              .success( (quotaUsed, value) )
            )
          }
        case .failure(let error):
          print("Error uploading file: \(error)")
          promise(.failure(error))
        }
      }
    }
    .eraseToAnyPublisher()
  }
}
