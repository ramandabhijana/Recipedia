//
//  RecipeDetailView+Ingredients.swift
//  Recipedia
//
//  Created by Abhijana Agung Ramanda on 13/11/20.
//

import SwiftUI
import SDWebImageSwiftUI
import Recipe

extension RecipeDetailView {
  var ingredientsView: some View {
    ForEach(
      presenter.dataModel.ingredients,
      id: \.identifier
    ) {
      makeIngredientsItem(for: $0)
      Divider()
    }
  }
  
  func makeIngredientsItem(
    for ingredient: RecipeDomainModel.Ingredient
  ) -> some View {
    HStack {
      WebImage(url: RecipeDomainModel.ingredientImageURL(for: ingredient.image))
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 80, height: 80)
        .padding(.trailing, 4)
      VStack(alignment: .leading, spacing: 8) {
        Text(ingredient.name)
          .foregroundColor(.black)
        Text(ingredient.amount)
          .font(.footnote)
          .foregroundColor(.secondary)
      }
    }
    .padding(.vertical, 8)
  }
}
