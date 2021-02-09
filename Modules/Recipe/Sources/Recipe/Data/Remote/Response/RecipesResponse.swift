//
//  RecipesResponse.swift
//  
//
//  Created by Abhijana Agung Ramanda on 01/01/21.
//

import Foundation

public struct RecipesResponse: Codable {
  let results: [RecipeResponse]
}

public struct RecipeResponse: Codable {
  let analyzedInstructions: [AnalyzedInstruction]?
  let extendedIngredients: [ExtendedIngredient]?
  let id: Int?
  let image: String?
  let nutrition: Nutrition?
  let readyInMinutes: Int?
  let servings: Int?
  let summary: String?
  let title: String?
}

public struct AnalyzedInstruction: Codable {
  let steps: [Step]?
}

public struct Step: Codable {
  let equipments: [Equipment]?
  let ingredients: [Ingredient]?
  let number: Int?
  let step: String?
  
  enum CodingKeys: String, CodingKey {
    case equipments = "equipment"
    case ingredients
    case number
    case step
  }
  
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    equipments = (try? values.decode([Equipment].self, forKey: .equipments)) ?? [Equipment]()
    ingredients = (try? values.decode([Ingredient].self, forKey: .ingredients)) ?? [Ingredient]()
    number = try? values.decode(Int.self, forKey: .number)
    step = try? values.decode(String.self, forKey: .step)
  }
}

public struct Equipment: Codable {
  let id: Int?
  let image: String?
  let localizedName: String?
}

public struct Ingredient: Codable {
  let id: Int?
  let image: String?
  let localizedName: String?
}

public struct ExtendedIngredient: Codable {
  let id = UUID()
  let amount: Float?
  let image: String
  let name: String?
  let unit: String?
  
  enum CodingKeys: String, CodingKey {
    case amount = "amount"
    case image = "image"
    case name = "originalName"
    case unit = "unit"
  }
  
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    amount = try? values.decode(Float.self, forKey: .amount)
    image = (try? values.decode(String.self, forKey: .image)) ??
      "no.jpg"
    name = try? values.decode(String.self, forKey: .name)
    unit = try? values.decode(String.self, forKey: .unit)
  }
}

public struct Nutrition: Codable {
  let caloricBreakdown: CaloricBreakdown?
  let nutrients: [Nutrient]?
}

public struct Nutrient: Codable {
  let amount: Float?
  let percentOfDailyNeeds: Float?
  let title: String?
  let unit: String?
}

public struct CaloricBreakdown: Codable {
  let percentCarbs: Float?
  let percentFat: Float?
  let percentProtein: Float?
}
