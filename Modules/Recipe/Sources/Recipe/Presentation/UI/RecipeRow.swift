//
//  RecipeRow.swift
//  Recipedia
//
//  Created by Abhijana Agung Ramanda on 09/11/20.
//

import SwiftUI
import SDWebImageSwiftUI

public struct RecipeRow: View {
  public var recipe: RecipeDomainModel
  
  public var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      WebImage(url: URL(string: recipe.image))
        .resizable()
        .indicator(.activity)
        .transition(.fade(duration: 0.5))
        .aspectRatio(contentMode: .fit)
        .cornerRadius(10)
      recipeInfo
    }
    .padding(.vertical, 20)
    .frame(width: 275, height: 275, alignment: .leading)
  }
}

extension RecipeRow {
  
  var recipeInfo: some View {
    VStack(alignment: .leading, spacing: 5) {
      Text(recipe.title)
        .font(.headline)
        .bold()
        .lineLimit(1)
        .foregroundColor(.black)
      recipeFootnoteView(for: recipe)
    }
  }
}

struct RecipeRow_Previews: PreviewProvider {
  static var previews: some View {
    RecipeRow(
      recipe: RecipeDomainModel(
        id: 0,
        title: "kimchi",
        image: "https://spoonacular.com/recipeImages/649002-312x231.jpg",
        servings: 3,
        readyInMinutes: 45,
        calories: "128 kcal",
        summary: "",
        caloricBreakdown: RecipeDomainModel.CaloricBreakdown(carbs: 30.2, fat: 40.2, protein: 20.3),
        ingredients: [RecipeDomainModel.Ingredient](),
        instructions: [RecipeDomainModel.Instruction]()
      )
    )
  }
}
