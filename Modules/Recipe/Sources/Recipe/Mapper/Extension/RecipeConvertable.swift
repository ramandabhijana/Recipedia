//
//  File.swift
//  
//
//  Created by Abhijana Agung Ramanda on 08/01/21.
//

import Foundation
import RealmSwift

public protocol RecipeConvertable {
  func convertToModel(from recipeResponse: RecipeResponse) -> RecipeDomainModel
  func convertToEntity(from domainModel: RecipeDomainModel) -> RecipeModuleEntity
  func convertToModel(from recipeEntity: RecipeModuleEntity) -> RecipeDomainModel
}

public extension RecipeConvertable {
  func convertToModel(from recipeResponse: RecipeResponse) -> RecipeDomainModel {
    RecipeDomainModel(
      id: recipeResponse.id ?? -1,
      title: recipeResponse.title ?? "Unknown",
      image: recipeResponse.image ?? "",
      servings: recipeResponse.servings ?? 0,
      readyInMinutes: recipeResponse.readyInMinutes ?? 0,
      calories: calories(from: recipeResponse),
      summary: recipeResponse.summary?.withoutHtmlTags ?? "No Information",
      caloricBreakdown: caloricBreakdown(from: recipeResponse),
      ingredients: ingredients(from: recipeResponse.extendedIngredients),
      instructions: instructions(from: recipeResponse.analyzedInstructions)
    )
  }
  
  func convertToEntity(from domainModel: RecipeDomainModel) -> RecipeModuleEntity {
    let entity = RecipeModuleEntity()
    entity.id = domainModel.id
    entity.title = domainModel.title
    entity.image = domainModel.image
    entity.servings = domainModel.servings
    entity.readyInMinutes = domainModel.readyInMinutes
    entity.calories = domainModel.calories
    entity.summary = domainModel.summary
    entity.breakdown = caloricBreakdownEntity(
      from: domainModel.caloricBreakdown
    )
    entity.ingredients = ingredientsEntity(
      from: domainModel.ingredients
    )
    entity.instructions = instructionsEntity(
      from: domainModel.instructions
    )
    return entity
  }
  
  func convertToModel(from recipeEntity: RecipeModuleEntity) -> RecipeDomainModel {
    RecipeDomainModel(
      id: recipeEntity.id,
      title: recipeEntity.title,
      image: recipeEntity.image,
      servings: recipeEntity.servings,
      readyInMinutes: recipeEntity.readyInMinutes,
      calories: recipeEntity.calories,
      summary: recipeEntity.summary,
      caloricBreakdown: caloricBreakdown(from: recipeEntity.breakdown),
      ingredients: ingredients(from: recipeEntity.ingredients),
      instructions: instructions(from: recipeEntity.instructions)
    )
  }
}

// MARK: - Response to Domain helper methods
private extension RecipeConvertable {
  private func calories(from response: RecipeResponse) -> String {
    let nutrients = response.nutrition?.nutrients
    guard let calories = nutrients?.first(where: {$0.title == "Calories"}),
          let amount = calories.amount
    else { return "0 kcal" }
    return "\(Int(amount)) \(calories.unit ?? "kcal")"
  }
  
  private func caloricBreakdown(
    from response: RecipeResponse
  ) -> RecipeDomainModel.CaloricBreakdown {
    let breakdown = response.nutrition?.caloricBreakdown
    return RecipeDomainModel.CaloricBreakdown(
      carbs: breakdown?.percentCarbs ?? 0.0,
      fat: breakdown?.percentFat ?? 0.0,
      protein: breakdown?.percentProtein ?? 0.0
    )
  }
  
  private func ingredients(
    from extendedIngredients: [ExtendedIngredient]?
  ) -> [RecipeDomainModel.Ingredient] {
    guard let ingredients = extendedIngredients
    else { return [] }
    return ingredients.map {
      RecipeDomainModel.Ingredient(
        identifier: $0.id,
        image: $0.image,
        name: $0.name ?? "Unknown",
        amount: "\($0.amount ?? 0) \($0.unit ?? "")"
      )
    }
  }
  
  private func instructions(
    from analyzedInstructions: [AnalyzedInstruction]?
  ) -> [RecipeDomainModel.Instruction] {
    guard
      let instructions = analyzedInstructions,
      let steps = instructions.first?.steps
    else { return [] }
    func equipments(
      _ step: Step?
    ) -> [RecipeDomainModel.Instruction.Equipment] {
      step?.equipments?.map {
        RecipeDomainModel.Instruction.Equipment(
          id: $0.id ?? -1,
          image: $0.image ?? "",
          name: $0.localizedName ?? ""
        )
      } ?? []
    }
    func ingredients(
      _ step: Step?
    ) -> [RecipeDomainModel.Instruction.Ingredient] {
      step?.ingredients?.map {
        RecipeDomainModel.Instruction.Ingredient(
          id: $0.id ?? -1,
          image: $0.image ?? "",
          name: $0.localizedName ?? ""
        )
      } ?? []
    }
    return steps.map {
      RecipeDomainModel.Instruction(
        number: $0.number ?? 0,
        description: $0.step ?? "",
        equipments: equipments($0),
        ingredients: ingredients($0)
      )
    }
  }
}

// MARK: - Domain to Entity helper methods
private extension RecipeConvertable {
  private func caloricBreakdownEntity(
    from caloricBreakdownModel: RecipeDomainModel.CaloricBreakdown
  ) -> CaloricBreakdownModuleEntity {
    let breakdown = CaloricBreakdownModuleEntity()
    breakdown.carbs = caloricBreakdownModel.carbs
    breakdown.fat = caloricBreakdownModel.fat
    breakdown.protein = caloricBreakdownModel.protein
    return breakdown
  }
  
  private func ingredientsEntity(
    from ingredientsModel: [RecipeDomainModel.Ingredient]
  ) -> List<IngredientModuleEntity> {
    let ingredients = List<IngredientModuleEntity>()
    ingredients.append(
      objectsIn: ingredientsModel
        .map { model -> IngredientModuleEntity in
          let entity = IngredientModuleEntity()
          entity.image = model.image
          entity.name = model.name
          entity.amount = model.amount
          return entity
        }
    )
    return ingredients
  }
  
  private func instructionsEntity(
    from instructionsModel: [RecipeDomainModel.Instruction]
  ) -> List<InstructionModuleEntity> {
    func equipmentsEntity(
      from instructionEquipments: [RecipeDomainModel.Instruction.Equipment]
    ) -> List<InstructionExtraModuleEntity> {
      let equipments = List<InstructionExtraModuleEntity>()
      equipments.append(
        objectsIn: instructionEquipments
          .map {
            let entity = InstructionExtraModuleEntity()
            entity.id = $0.id
            entity.image = $0.image
            entity.name = $0.name
            return entity
          }
      )
      return equipments
    }
    func ingredientsEntity(
      from instructionIngredients: [RecipeDomainModel.Instruction.Ingredient]
    ) -> List<InstructionExtraModuleEntity> {
      let ingredients = List<InstructionExtraModuleEntity>()
      ingredients.append(
        objectsIn: instructionIngredients
          .map {
            let entity = InstructionExtraModuleEntity()
            entity.id = $0.id
            entity.image = $0.image
            entity.name = $0.name
            return entity
          }
      )
      return ingredients
    }
    let instructions = List<InstructionModuleEntity>()
    instructions.append(
      objectsIn: instructionsModel
        .map { model -> InstructionModuleEntity in
          let entity = InstructionModuleEntity()
          entity.number = model.number
          entity.desc = model.description
          entity.equipments = equipmentsEntity(from: model.equipments)
          entity.ingredients = ingredientsEntity(from: model.ingredients)
          return entity
        }
    )
    return instructions
  }
}

// MARK: - Entity to Domain helper methods
private extension RecipeConvertable {
  private func caloricBreakdown(
    from caloricBreakdownEntity: CaloricBreakdownModuleEntity?
  ) -> RecipeDomainModel.CaloricBreakdown {
    RecipeDomainModel.CaloricBreakdown(
      carbs: caloricBreakdownEntity?.carbs ?? 0,
      fat: caloricBreakdownEntity?.fat ?? 0,
      protein: caloricBreakdownEntity?.protein ?? 0
    )
  }
  
  private func ingredients(
    from ingredientsEntity: List<IngredientModuleEntity>
  ) -> [RecipeDomainModel.Ingredient] {
    ingredientsEntity.map {
      RecipeDomainModel.Ingredient(
        identifier: $0.id,
        image: $0.image,
        name: $0.name,
        amount: $0.amount
      )
    }
  }
  
  private func instructions(
    from instructionsEntity: List<InstructionModuleEntity>
  ) -> [RecipeDomainModel.Instruction] {
    return instructionsEntity.map {
      RecipeDomainModel.Instruction(
        number: $0.number,
        description: $0.desc,
        equipments: $0.equipments.map {
          RecipeDomainModel.Instruction.Equipment(
            id: $0.id, image: $0.image, name: $0.name
          )
        },
        ingredients: $0.ingredients.map {
          RecipeDomainModel.Instruction.Ingredient(
            id: $0.id, image: $0.image, name: $0.name
          )
        }
      )
    }
  }
}
