//
//  File.swift
//  
//
//  Created by Abhijana Agung Ramanda on 15/01/21.
//

import Core

public struct AutocompleteMapper: Mapper {
  public typealias Response = AutocompleteResponse
  public typealias Entity = Any
  public typealias Domain = AutocompleteDomainModel
  
  public init() { }
  
  public func mapResponseToDomain(_ response: AutocompleteResponse) -> AutocompleteDomainModel {
    AutocompleteDomainModel(
      id: response.id ?? Int.init(),
      title: response.title ?? "Unknown"
    )
  }
  
  public func mapEntityToDomain(_ entity: Any) -> AutocompleteDomainModel {
    fatalError("not implemented")
  }
  
  public func mapDomainToEntity(_ domain: AutocompleteDomainModel) -> Any {
    (Any).self
  }
}


