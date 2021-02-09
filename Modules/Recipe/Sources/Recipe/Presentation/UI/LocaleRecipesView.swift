//
//  LocaleRecipesView.swift
//  Recipedia
//
//  Created by Abhijana Agung Ramanda on 25/11/20.
//

import SwiftUI
import Core
import Introspect

public struct LocaleRecipesView<Detail: View>: View {
  private let goToDetail: (RecipeDomainModel) -> Detail
  
  @State private var tabBar: UITabBar?
  @ObservedObject var presenter: FavoritePresenter
  
  public init(
    presenter: FavoritePresenter,
    goToDetail: @escaping (RecipeDomainModel) -> Detail
  ) {
    self.presenter = presenter
    self.goToDetail = goToDetail
  }
  
  public var body: some View {
    NavigationView {
      ZStack {
        switch presenter.state {
        case .empty:
          PlaceholderView(
            imageSystemName: "bookmark.circle",
            descriptionText: "Your favorite recipes will be appeared here."
          )
        case .error(let message):
          makeErrorView(with: message)
        case .loading:
          loadingView
        case .populated:
          List {
            ForEach( presenter.filteredRecipes() ) { recipe in
              NavigationLink(
                destination: self.goToDetail(recipe)
              ) {
                RecipeRow(recipe: recipe)
                  .animation(nil)
              }
            }
          }
          .listStyle(InsetGroupedListStyle())
        }
      }
      .animation(.easeIn)
      .addSearchBar(
        SearchBar(
          canEdit: true,
          text: $presenter.searchText,
          isEditing: $presenter.isSearching
        ),
        hideWhenScrolling: true
      )
      .navigationBarTitle(
        Text("Favorites"),
        displayMode: .automatic
      )
    }
    .navigationViewStyle(StackNavigationViewStyle())
  }
  
}
