//
//  File.swift
//  
//
//  Created by Abhijana Agung Ramanda on 16/01/21.
//

import Foundation

public struct ClassificationDomainModel {
  public let category: String
  public let probability: Float
  
  public var formattedCategory: String {
    let category = self.category.replacingOccurrences(of: "_", with: " ")
    return category.prefix(1).capitalized + category.dropFirst()
  }
  
  public var isConfident: Bool { probability > 0.80 }
  
  public init(category: String, probability: Float) {
    self.category = category
    self.probability = probability
  }
}
