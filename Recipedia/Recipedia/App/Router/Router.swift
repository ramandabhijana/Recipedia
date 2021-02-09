//
//  Router.swift
//  Recipedia
//
//  Created by Abhijana Agung Ramanda on 01/02/21.
//

import SwiftUI
import Recipe
import RecipeDetail
import AutocompleteSearch
import ImageClassification
import struct Core.LazyView

final class Router {
  
  func makeDetailView(for recipe: RecipeDomainModel) -> LazyView<RecipeDetailView> {
    guard let useCase: GetDetailUseCase = Injection().provideDetailRecipe(model: recipe)
    else { fatalError(useCaseErrorMessage) }
    let presenter = GetDetailPresenter(
      useCase: useCase,
      dataModelId: recipe.id
    )
    return LazyView(RecipeDetailView(presenter: presenter))
  }
  
  func makeDetailView(with id: Int) -> LazyView<RecipeDetailView> {
    let unpresentableRecipe = RecipeDomainModel(
      id: id,
      title: "",
      image: "",
      servings: 0,
      readyInMinutes: 0,
      calories: "",
      summary: "",
      caloricBreakdown: RecipeDomainModel.CaloricBreakdown(
        carbs: 0, fat: 0, protein: 0
      ),
      ingredients: [RecipeDomainModel.Ingredient](),
      instructions: [RecipeDomainModel.Instruction]()
    )
    return self.makeDetailView(for: unpresentableRecipe)
  }
  
  func makeClassificationView() -> ClassificationView {
    guard let useCase: ClassificationUseCase = Injection().provideClassification()
    else { fatalError(useCaseErrorMessage) }
    let presenter = GetClassificationPresenter(useCase: useCase)
    return ClassificationView(presenter: presenter)
  }
  
  func makeAutocompleteSearch(
    presenter: GetAutocompletePresenter
  ) -> GetAutocompleteSearchView {
    GetAutocompleteSearchView(
      presenter: presenter,
      goToDetail: makeDetailView(with:),
      goToClassification: makeClassificationView
    )
  }
}

let useCaseErrorMessage = "Invalid use case provided; Fail to cast the interactor;"
