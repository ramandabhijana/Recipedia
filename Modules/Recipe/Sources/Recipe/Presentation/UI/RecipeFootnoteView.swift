//
//  RecipeFootnote.swift
//  Recipedia
//
//  Created by Abhijana Agung Ramanda on 04/12/20.
//

import SwiftUI

public func recipeFootnoteView(for recipe: RecipeDomainModel) -> some View {
  HStack(spacing: 30) {
    HStack {
      Image(systemName: "person")
      Text("\(recipe.servings)")
    }
    HStack {
      Image(systemName: "flame")
      Text("\(recipe.calories)")
    }
    HStack {
      Image(systemName: "clock")
      Text("\(recipe.readyInMinutes) min")
    }
  }
  .font(.footnote)
  .foregroundColor(.secondary)
}
