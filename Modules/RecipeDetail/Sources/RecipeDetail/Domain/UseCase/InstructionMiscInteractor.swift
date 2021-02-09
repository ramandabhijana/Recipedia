//
//  File.swift
//  
//
//  Created by Abhijana Agung Ramanda on 14/01/21.
//

import Foundation

public protocol InstructionMiscUseCase {
  associatedtype Request
  associatedtype Response
  
  var list: [Response] { get }
  var title: String { get }
}

public class InstructionMiscInteractor: InstructionMiscUseCase {
  public typealias Request = InstructionMiscDataSourceType
  public typealias Response = InstructionMisc
  
  private let dataSourceType: Request
  
  public var list: [Response]
  public var title: String { dataSourceType.rawValue }
  
  public init(
    dataSourceType: InstructionMiscInteractor.Request,
    list: [InstructionMiscInteractor.Response]
  ) {
    self.dataSourceType = dataSourceType
    self.list = list
  }
}

public enum InstructionMiscDataSourceType: String {
  case equipments = "Equipments"
  case ingredients = "Ingredients"
}
