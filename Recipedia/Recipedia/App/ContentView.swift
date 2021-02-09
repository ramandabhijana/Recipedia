//
//  ContentView.swift
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

struct ContentView: View {
  @State private var tabSelection: Tabs = .home
  
  @EnvironmentObject var homePresenter: HomePresenter
  @EnvironmentObject var favoritePresenter: FavoritePresenter
  @EnvironmentObject var autocompletePresenter: GetAutocompletePresenter
  
  private enum Tabs: String {
    case home = "Home"
    case favorite = "Favorites"
    case profile = "Profile"
  }
  
  private let router = Router()
  
  init() {
    setupUIAppearance()
  }
  
  var body: some View {
    TabView(selection: $tabSelection) {
      homeView
      favoritesView
      profileView
    }
    .accentColor(.white)
    .navigationTitle(tabSelection.rawValue)
  }
}

// MARK: - Tab Item
extension ContentView {
  
  private var homeView: some View {
    RemoteRecipesView<
      GetRecipeDetailView,
      GetAutocompleteSearchView
    >(
      presenter: homePresenter,
      goToDetail: router.makeDetailView(for:),
      goToSearch: { router.makeAutocompleteSearch(presenter: autocompletePresenter) }
    )
    .foregroundColor(.secondary)
    .tabItem {
      Image(systemName: homeImageName)
      Text(Tabs.home.rawValue)
    }
    .tag(Tabs.home)
  }
  
  private var favoritesView: some View {
    LocaleRecipesView<GetRecipeDetailView>(
      presenter: favoritePresenter,
      goToDetail: router.makeDetailView(for:)
    )
    .foregroundColor(.secondary)
    .tabItem {
      Image(systemName: favoritesImageName)
      Text(Tabs.favorite.rawValue)
    }
    .tag(Tabs.favorite)
  }
  
  private var profileView: some View {
    AuthorView()
      .tabItem {
        Image(systemName: profileImageName)
        Text(Tabs.profile.rawValue)
      }
      .tag(Tabs.profile)
  }
}

extension ContentView {
  private func setupUIAppearance() {
    UINavigationBar.appearance().tintColor = .purple
    
    UITabBar.appearance().shadowImage = UIImage()
    UITabBar.appearance().backgroundImage = UIImage()
    UITabBar.appearance().isTranslucent = true
    UITabBar.appearance().backgroundColor = UIColor(named: "PrimaryColor")
    UITabBar.appearance().barTintColor = UIColor(named: "PrimaryColor")
    UITabBar.appearance().unselectedItemTintColor = UIColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.8047233733))
    
    UIBarButtonItem
      .appearance(
        whenContainedInInstancesOf: [UISearchBar.self]
      )
      .setTitleTextAttributes(
        [ .foregroundColor: UIColor.purple,
          .font: UIFont.systemFont(ofSize: 17)
        ],
        for: .normal
      )
    
    UIView
      .appearance(
        whenContainedInInstancesOf: [UIAlertController.self]
      )
      .tintColor = .purple
  }
}

// MARK: - TabItem Image Name
extension ContentView {
  private var homeImageName: String {
    tabSelection == .home ? "house.fill" : "house"
  }
  
  private var favoritesImageName: String {
    tabSelection == .favorite ? "bookmark.fill" : "bookmark"
  }
  
  private var profileImageName: String {
    tabSelection == .profile ?
      "person.crop.circle.fill" :
      "person.crop.circle"
  }
}

// MARK: - Type Alias
typealias GetAutocompleteSearchView = AutocompleteSearchView<
  LazyView<RecipeDetailView>,
  ClassificationView
>

typealias GetRecipeDetailView = LazyView<RecipeDetailView>
