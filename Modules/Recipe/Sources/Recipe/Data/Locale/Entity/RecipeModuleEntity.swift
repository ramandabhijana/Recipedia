//
//  RecipeModuleEntity.swift
//  
//
//  Created by Abhijana Agung Ramanda on 01/01/21.
//

import Foundation
import RealmSwift

public class RecipeModuleEntity: Object {
  @objc dynamic var id: Int = .min
  @objc dynamic var title = ""
  @objc dynamic var image = ""
  @objc dynamic var servings = 0
  @objc dynamic var readyInMinutes = 0
  @objc dynamic var calories = ""
  @objc dynamic var summary = ""
  @objc dynamic var breakdown: CaloricBreakdownModuleEntity?
  var ingredients = List<IngredientModuleEntity>()
  var instructions = List<InstructionModuleEntity>()
  
  public override class func primaryKey() -> String? { "id" }
  
  public override func isEqual(_ object: Any?) -> Bool {
    guard let rhs = object as? RecipeModuleEntity else { return false }
    return self.id == rhs.id
  }
}

public class CaloricBreakdownModuleEntity: Object {
  @objc dynamic var carbs: Float = .zero
  @objc dynamic var fat: Float = .zero
  @objc dynamic var protein: Float = .zero
}

public class IngredientModuleEntity: Object {
  public let id = UUID()
  @objc dynamic var image = ""
  @objc dynamic var name = ""
  @objc dynamic var amount = ""
}

public class InstructionModuleEntity: Object {
  @objc dynamic var number = 1
  @objc dynamic var desc = ""
  var equipments = List<InstructionExtraModuleEntity>()
  var ingredients = List<InstructionExtraModuleEntity>()
}

public class InstructionExtraModuleEntity: Object {
  @objc dynamic var id: Int = .min
  @objc dynamic var image = ""
  @objc dynamic var name = ""
}
