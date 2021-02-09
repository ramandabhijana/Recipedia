//
//  File.swift
//  
//
//  Created by Abhijana Agung Ramanda on 16/01/21.
//

import Foundation
import Combine
import Core

public class ClassificationRepository<
  Remote: RemoteDataSource,
  Transformer: Mapper
>: Repository
where
  Remote.Request == Data,
  Remote.Response == (Float, ClassificationResponse),
  Transformer.Response == ClassificationResponse,
  Transformer.Domain == ClassificationDomainModel {
  
  public typealias Request = Data
  public typealias Response = ClassificationDomainModel
  
  private var remoteDataSource: Remote
  private let mapper: Transformer
  
  public init(
    remoteDataSource: Remote,
    mapper: Transformer
  ) {
    self.remoteDataSource = remoteDataSource
    self.mapper = mapper
  }
  
  public func execute(request: Data) -> AnyPublisher<ClassificationDomainModel, Error> {
    remoteDataSource.execute(request: request)
      .map { [unowned self] response -> ClassificationDomainModel in
        QuotaManager.shared.set(response.0)
        return self.mapper.mapResponseToDomain(response.1)
      }
      .eraseToAnyPublisher()
  }
  
}
