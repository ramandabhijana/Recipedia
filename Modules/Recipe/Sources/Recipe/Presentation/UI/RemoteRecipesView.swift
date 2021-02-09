//
//  RemoteRecipesView.swift
//  Recipedia
//
//  Created by Abhijana Agung Ramanda on 09/11/20.
//

import SwiftUI
import Introspect
import ActivityIndicatorView
import Core

public struct RemoteRecipesView<Detail: View, Search: View>: View {
  @State private var sheetOffset: CGFloat = UIScreen.main.bounds.height
  @State private var tabBar: UITabBar?
  @ObservedObject var presenter: HomePresenter
  
  private let goToDetail: (RecipeDomainModel) -> Detail
  private let goToSearch: () -> Search
  private var isShowingSheet: Bool {
    sheetOffset <= 100
  }
  
  public init(
    presenter: HomePresenter,
    goToDetail: @escaping (RecipeDomainModel) -> Detail,
    goToSearch: @escaping () -> Search
  ) {
    self.presenter = presenter
    self.goToDetail = goToDetail
    self.goToSearch = goToSearch
  }
  
  public var body: some View {
    NavigationView {
      ZStack {
        switch presenter.state {
        case .loading:
          loadingView
        case .empty:
          PlaceholderView(
            imageSystemName: "clear.fill",
            descriptionText: "No results found"
          )
        case .error(let message):
          makeErrorView(with: message)
        case .populated:
          RecipesList(
            recipes: presenter.list,
            isLoading: presenter.isLoadingData,
            showLoadMoreButton: presenter.canLoadMoreData,
            goToDetail: goToDetail,
            onScrolledAtBottom: presenter.loadMoreContentIfNeeded
          )
        }
        NavigationLink(
          destination: goToSearch(),
          isActive: $presenter.isSearching,
          label: { EmptyView() }
        )
        quotaUsedView
      }
      .navigationBarTitle(
        Text("Recipes"),
        displayMode: .large
      )
      .navigationBarItems(
        leading: Button(
          action: { self.sheetOffset = 0 },
          label: { quotaUsedButtonLabel }
        ),
        trailing: Button(
          action: { presenter.isSearching.toggle() },
          label: { searchButtonLabel }
        )
      )
      .snackBar(
        isShowing: $presenter.showingNetworkStatusMessage,
        text: Text(presenter.networkStatusMessage)
      )
      .introspectTabBarController { controller in
        tabBar = controller.tabBar
        controller.hidesBottomBarWhenPushed = true
        tabBar?.isHidden = isShowingSheet
      }
    }
    .navigationViewStyle(StackNavigationViewStyle())
  }
}

struct RecipesList<Destination: View>: View {
  let recipes: [RecipeDomainModel]
  let isLoading: Bool
  let showLoadMoreButton: Bool
  let goToDetail: (RecipeDomainModel) -> Destination
  let onScrolledAtBottom: () -> Void
  
  var body: some View {
    List {
      recipeList
      if showLoadMoreButton { loadMoreButton }
      if isLoading {
        ProgressView()
          .frame(maxWidth: .infinity, alignment: .center)
      }
    }
    .accessibility(identifier: "remote_recipes")
    .listStyle(InsetGroupedListStyle())
  }
  
  private var loadMoreButton: some View {
    Button(
      action: {
        onScrolledAtBottom()
      },
      label: {
        Text("Load more recipes")
          .foregroundColor(Color(.purple))
      }
    )
    .frame(maxWidth: .infinity, alignment: .center)
  }
  
  private var recipeList: some View {
    ForEach(recipes) { recipe in
      NavigationLink(destination: self.goToDetail(recipe)) {
        RecipeRow(recipe: recipe)
      }
    }
  }
}

extension RemoteRecipesView {
  private var quotaUsedButtonLabel: some View {
    ZStack {
      Group {
        Capsule().stroke(lineWidth: 1.5)
        Text("\(QuotaManager.shared.point)")
          .font(.subheadline)
          .padding(.horizontal)
      }
      .foregroundColor(Color(.purple))
    }
  }
  
  private var searchButtonLabel: some View {
    Image(systemName: "magnifyingglass.circle")
      .foregroundColor(Color(UIColor.purple))
      .font(.title2)
  }
}

extension RemoteRecipesView {
  private var quotaUsedView: some View {
    VStack {
      Spacer()
      quotaUsedSheetView
        .offset(y: sheetOffset)
        .gesture(
          DragGesture()
            .onChanged { value in
              if value.translation.height > 0 {
                sheetOffset = value.location.y
              }
            }
            .onEnded { _ in
              if sheetOffset > 100 {
                sheetOffset = UIScreen.main.bounds.height
              } else {
                sheetOffset = 0
              }
            }
        )
    }
    .frame(width: UIScreen.main.bounds.width)
    .background(
      (sheetOffset <= 100 ?
        Color.black.opacity(0.3) :
        Color.clear
      )
      .edgesIgnoringSafeArea(.all)
      .onTapGesture {
        sheetOffset = UIScreen.main.bounds.height
      }
    )
    .edgesIgnoringSafeArea(.bottom)
    .animation(.easeIn(duration: 0.5))
  }
}
