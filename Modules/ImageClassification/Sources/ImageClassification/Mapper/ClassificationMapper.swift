//
//  File.swift
//  
//
//  Created by Abhijana Agung Ramanda on 16/01/21.
//

import Foundation
import Core

public struct ClassificationMapper: Mapper {
  public typealias Response = ClassificationResponse
  public typealias Entity = Any
  public typealias Domain = ClassificationDomainModel
  
  public init() { }
  
  public func mapResponseToDomain(_ response: ClassificationResponse) -> ClassificationDomainModel {
    ClassificationDomainModel(
      category: response.category ?? "Not determined",
      probability: response.probability ?? 0.0
    )
  }
  
  public func mapEntityToDomain(_ entity: Any) -> ClassificationDomainModel {
    fatalError("mapEntityToDomain(_:) is not implemented")
  }
  
  public func mapDomainToEntity(_ domain: ClassificationDomainModel) -> Any {
    (Any).self
  }
}
