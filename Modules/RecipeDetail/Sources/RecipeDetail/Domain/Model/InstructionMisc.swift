//
//  File.swift
//  
//
//  Created by Abhijana Agung Ramanda on 14/01/21.
//

import Foundation

// Can be Instruction's Equipments or Ingredients
public struct InstructionMisc {
  public let identifier: Int
  public let image: URL?
  public let name: String
  
  public init(identifier: Int, image: URL?, name: String) {
    self.identifier = identifier
    self.image = image
    self.name = name
  }
}
