//
//  AutocompleteSearchView.swift
//  Recipedia
//
//  Created by Abhijana Agung Ramanda on 20/11/20.
//

import SwiftUI
import Core
import typealias Recipe.HomePresenter

public struct AutocompleteSearchView<
  Detail: View,
  Classification: View
>: View {
  
  private let goToDetail: (Int) -> Detail
  private let goToClassification: () -> Classification
  
  @State private var showingDetail = false
  @State private var showingClassification: Bool = false
  @ObservedObject private var presenter: GetAutocompletePresenter
  @EnvironmentObject var homePresenter: HomePresenter
  
  public init(
    presenter: GetAutocompletePresenter,
    goToDetail: @escaping (Int) -> Detail,
    goToClassification: @escaping () -> Classification
  ) {
    self.presenter = presenter
    self.goToDetail = goToDetail
    self.goToClassification = goToClassification
  }
  
  public var body: some View {
    ZStack {
      Color(.systemGroupedBackground)
        .edgesIgnoringSafeArea(.all)
      switch presenter.state {
      case .empty:
        PlaceholderView(
          imageSystemName: "doc.text.magnifyingglass",
          descriptionText: "Find your beloved food recipes"
        )
      case .loading:
        loadingView
      case .error(let message):
        makeErrorView(with: message)
      case .populated:
        List(presenter.list) { item in
          NavigationLink(
            destination: goToDetail(item.id),
            label: {
              ListRow(item: item)
            }
          )
        }
        .accessibility(identifier: "results")
        .listStyle(InsetGroupedListStyle())
      }
      NavigationLink(
        destination: goToClassification(),
        isActive: $showingClassification,
        label: { EmptyView() }
      )
    }
    .animation(.easeIn)
    .addSearchBar(
      searchBar,
      hideWhenScrolling: false,
      becomeFirstResponder: true
    )
    .navigationBarTitle("Search")
    .navigationBarItems(trailing: imageClassificationButton)
  }
  
  private var searchBar: SearchBar {
    return SearchBar(
      canEdit: true,
      text: $presenter.searchText,
      isEditing: $presenter.isSearching
    ) {
      homePresenter.setRequest(.name(presenter.searchText))
      homePresenter.isSearching.toggle()
    }
  }
  
}

extension AutocompleteSearchView {
  private var imageClassificationButton: some View {
    Button(
      action: { showingClassification.toggle() },
      label: {
        Image(systemName: "photo")
          .foregroundColor(Color(.purple))
      }
    )
  }
}

private struct ListRow: View {
  var item: AutocompleteDomainModel
  var body: some View {
    Text(item.title)
  }
}
