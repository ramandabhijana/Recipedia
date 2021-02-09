//
//  RecipeExtraDetailView.swift
//  Recipedia
//
//  Created by Abhijana Agung Ramanda on 04/12/20.
//

import SwiftUI

extension RecipeDetailView {
  private var segments: [String] {
    ["Ingredients", "Instructions"]
  }
  
  var recipeExtraDetailView: some View {
    VStack(alignment: .leading) {
      Picker(
        "Recipe",
        selection: $selectedPickerIndex.animation()
      ) {
        ForEach(0 ..< segments.count) {
          Text(self.segments[$0]).tag($0)
        }
      }
      .pickerStyle(SegmentedPickerStyle())
      switch selectedPickerIndex {
      case 1: instructionsView
      default: ingredientsView
      }
    }
    .padding(.horizontal)
  }
}
