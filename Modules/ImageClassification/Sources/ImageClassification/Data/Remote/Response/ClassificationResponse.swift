//
//  File.swift
//  
//
//  Created by Abhijana Agung Ramanda on 16/01/21.
//

import Foundation

public struct ClassificationResponse: Decodable {
  let category: String?
  let probability: Float?
}
