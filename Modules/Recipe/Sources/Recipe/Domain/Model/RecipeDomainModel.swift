//
//  RecipeDomainModel.swift
//  
//
//  Created by Abhijana Agung Ramanda on 02/01/21.
//

import Foundation

public struct RecipeDomainModel: Equatable, Identifiable {
  public let id: Int
  public let title: String
  public let image: String
  public let servings: Int
  public let readyInMinutes: Int
  public let calories: String
  public let summary: String
  public let caloricBreakdown: CaloricBreakdown
  public let ingredients: [Ingredient]
  public let instructions: [Instruction]
  public var canAppear: Bool { !image.isEmpty }
  
  public static func equipmentImageURL(for imageName: String) -> URL? {
    URL(string: "https://spoonacular.com/cdn/equipment_100x100/\(imageName)")
  }
  
  public static func ingredientImageURL(for imageName: String) -> URL? {
    URL(string: "https://spoonacular.com/cdn/ingredients_100x100/\(imageName)")
  }
  
  public init(
    id: Int,
    title: String,
    image: String,
    servings: Int,
    readyInMinutes: Int,
    calories: String,
    summary: String,
    caloricBreakdown: RecipeDomainModel.CaloricBreakdown,
    ingredients: [RecipeDomainModel.Ingredient],
    instructions: [RecipeDomainModel.Instruction]
  ) {
    self.id = id
    self.title = title
    self.image = image
    self.servings = servings
    self.readyInMinutes = readyInMinutes
    self.calories = calories
    self.summary = summary
    self.caloricBreakdown = caloricBreakdown
    self.ingredients = ingredients
    self.instructions = instructions
  }
  
  public struct CaloricBreakdown {
    public let carbs: Float
    public let fat: Float
    public let protein: Float
    
    public init(carbs: Float, fat: Float, protein: Float) {
      self.carbs = carbs
      self.fat = fat
      self.protein = protein
    }
  }
  
  public struct Ingredient {
    public let identifier: UUID
    public let image: String
    public let name: String
    public let amount: String
    
    public init(identifier: UUID, image: String, name: String, amount: String) {
      self.identifier = identifier
      self.image = image
      self.name = name
      self.amount = amount
    }
  }
  
  public struct Instruction {
    public let number: Int
    public let description: String
    public let equipments: [Equipment]
    public let ingredients: [Self.Ingredient]
    
    public init(
      number: Int,
      description: String,
      equipments: [RecipeDomainModel.Instruction.Equipment],
      ingredients: [RecipeDomainModel.Instruction.Ingredient]
    ) {
      self.number = number
      self.description = description
      self.equipments = equipments
      self.ingredients = ingredients
    }
    
    public struct Equipment {
      public let id: Int
      public let image: String
      public let name: String
      
      public var imageURL: URL? {
        RecipeDomainModel.equipmentImageURL(for: image)
      }
      
      public init(id: Int, image: String, name: String) {
        self.id = id
        self.image = image
        self.name = name
      }
    }
    
    public struct Ingredient {
      public let id: Int
      public let image: String
      public let name: String
      
      public var imageURL: URL? {
        RecipeDomainModel.ingredientImageURL(for: image)
      }
      
      public init(id: Int, image: String, name: String) {
        self.id = id
        self.image = image
        self.name = name
      }
    }
  }
  
  public static func == (lhs: RecipeDomainModel, rhs: RecipeDomainModel) -> Bool {
    lhs.id == rhs.id
  }
}
