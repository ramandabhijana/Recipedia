//
//  File.swift
//  
//
//  Created by Abhijana Agung Ramanda on 15/01/21.
//

import Foundation
import Combine
import Core

public class AutocompleteRepository<
  Remote: RemoteDataSource,
  Transformer: Mapper
>: Repository
where
  Remote.Request == String,
  Remote.Response == (Float, [AutocompleteResponse]),
  Transformer.Response == AutocompleteResponse,
  Transformer.Domain == AutocompleteDomainModel {
  
  public typealias Request = String
  public typealias Response = [AutocompleteDomainModel]
  
  private var remoteDataSource: Remote
  private let mapper: Transformer
  
  public init(
    remoteDataSource: Remote,
    mapper: Transformer
  ) {
    self.remoteDataSource = remoteDataSource
    self.mapper = mapper
  }
  
  public func execute(request: String) -> AnyPublisher<[AutocompleteDomainModel], Error> {
    remoteDataSource.execute(request: request)
      .map { [unowned self] response -> [AutocompleteDomainModel] in
        QuotaManager.shared.set(response.0)
        return response.1.map { self.mapper.mapResponseToDomain($0) }
      }
      .eraseToAnyPublisher()
  }
  
}
