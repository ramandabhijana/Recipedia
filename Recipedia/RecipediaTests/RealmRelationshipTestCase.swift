//
//  RealmRelationshipTestCase.swift
//  RecipediaTests
//
//  Created by Abhijana Agung Ramanda on 07/02/21.
//

import XCTest
@testable import RealmSwift
@testable import Recipe

//swiftlint:disable force_try
class RealmRelationshipTestCase: XCTestCase {
  
  override func setUp() {
    Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
    let realm = try! Realm()
    try! realm.write {
      realm.deleteAll()
    }
  }
  
  func testToOneRelationship_RecipeAndCaloricBreakdown() {
    /**
     Skenario
     1.   Membuat instance recipe bertipe `RecipeModuleEntity`
     2.   Membuat instance breakdown bertipe `CaloricBreakdownEntity`
     3.   Tetapkan instance breakdown sebagai properti dari instance recipe
     4.   Simpan instance recipe ke database
     5.   Pastikan instance recipe berhasil tersimpan dan instance
     breakdown juga tersimpan ke database sebagai properti breakdown dari instance recipe
     */
    let recipe = RecipeModuleEntity()
    
    let breakdown = CaloricBreakdownModuleEntity()
    (breakdown.carbs, breakdown.fat, breakdown.protein) = (1, 2, 3)
    
    recipe.breakdown = breakdown
    
    let realm = try! Realm()
    try! realm.write { realm.add(recipe) }
    let savedRecipe = realm.objects(RecipeModuleEntity.self).last
    
    XCTAssertNotNil(savedRecipe)
    XCTAssertEqual(recipe, savedRecipe)
    
    XCTAssertNotNil(savedRecipe?.breakdown)
    XCTAssert(
      (
        savedRecipe!.breakdown!.fat,
        savedRecipe!.breakdown!.carbs,
        savedRecipe!.breakdown!.protein
      )
      == (breakdown.fat, breakdown.carbs, breakdown.protein)
    )
  }
  
  func testToManyRelationship_RecipeAndIngredients() {
    /**
     Skenario
     1.   Membuat instance recipe bertipe `RecipeModuleEntity`
     2.   Membuat 2 buah instance ingredient bertipe `IngredientModuleEntity`
     3.   Tambahkan kedua buah instance tersebut ke properti bahan-bahan (ingredients)
     milik instance recipe
     4.   Simpan instance recipe ke database
     5.   Pastikan instance recipe berhasil tersimpan dan kedua instance
     ingredient juga tersimpan ke database sebagai properti ingredients dari instance recipe
     */
    let recipe = RecipeModuleEntity()
    
    let ingredient0 = IngredientModuleEntity()
    let ingredient1 = IngredientModuleEntity()
    (ingredient0.name, ingredient1.name) = ("Onion", "MSG")
    
    recipe.ingredients.append(ingredient0)
    recipe.ingredients.append(ingredient1)
    
    let realm = try! Realm()
    try! realm.write { realm.add(recipe) }
    
    XCTAssert(realm.objects(RecipeModuleEntity.self).count == 1)
    let savedRecipe = realm.objects(RecipeModuleEntity.self).last
    
    XCTAssertNotNil(savedRecipe)
    XCTAssertEqual(recipe, savedRecipe)
    
    XCTAssertFalse(savedRecipe!.ingredients.isEmpty)
    XCTAssert(savedRecipe!.ingredients.count == 2)
    XCTAssert(savedRecipe!.ingredients[0].name == "Onion")
    XCTAssert(savedRecipe!.ingredients[1].name == "MSG")
  }
  
}
