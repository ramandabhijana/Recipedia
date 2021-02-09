//
//  File.swift
//  
//
//  Created by Abhijana Agung Ramanda on 15/01/21.
//

import Foundation

public struct AutocompleteDomainModel: Identifiable {
  public let id: Int
  public let title: String
  
  public init(id: Int, title: String) {
    self.id = id
    self.title = title
  }
}
