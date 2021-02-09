//
//  RecipeDetailView.swift
//  Recipedia
//
//  Created by Abhijana Agung Ramanda on 12/11/20.
//

import SwiftUI
import SDWebImageSwiftUI
import func Recipe.recipeFootnoteView
import Core
import Introspect

public struct RecipeDetailView: View {
  @State private var showSnackBar = false
  @State internal var selectedPickerIndex = 0
  @State private var navigationBar: UINavigationBar?
  @State private var tabBar: UITabBar?
  @State private var isOpaqueNavigationBar = false
  @StateObject internal var presenter: GetDetailPresenter
  
  public init(presenter: GetDetailPresenter) {
    _presenter = StateObject(wrappedValue: presenter)
  }
  
  public var body: some View {
    ZStack {
      switch presenter.state {
      case .loading:
        loadingView
          .frame(maxWidth: .infinity, alignment: .center)
      case .error(let message):
        makeErrorView(with: message)
      case .empty:
        Text("Empty")
      case .populated:
        ScrollView(.vertical, showsIndicators: false) {
          VStack {
            headerImage
            VStack(spacing: 10) {
              VStack(alignment: .leading, spacing: 5) {
                Text(presenter.dataModel.title)
                  .font(.title)
                  .bold()
                  .foregroundColor(.black)
                  .animation(.default)
                  .accessibility(identifier: "title")
                recipeFootnoteView(for: presenter.dataModel)
                  .padding(.bottom)
                ExpandableTextView(
                  text: presenter.dataModel.summary
                )
              }
              .padding(.horizontal)
              ScrollView(.horizontal, showsIndicators: false) {
                caloricBreakDownView
                  .padding(.horizontal)
                  .padding(.bottom)
              }
              recipeExtraDetailView
            }
            .padding(.vertical)
            .background(Color.white)
          }
        }
        .onAppear {
          presenter.checkIsInLocalDB()
          if !presenter.dataModel.canAppear {
            presenter.fetchRecipe()
          }
        }
      }
    }
    .edgesIgnoringSafeArea(.all)
    .onDisappear {
      navigationBar?.tintColor = .purple
      tabBar?.layer.zPosition = 0
      tabBar?.isUserInteractionEnabled = true
    }
    .navigationBarItems(
      trailing: Button(
        action: {
          presenter.onAddToLocalButtonClicked()
          self.showSnackBar.toggle()
        },
        label: { favoriteButtonLabel }
      )
    )
    .snackBar(
      isShowing: $showSnackBar,
      text: Text(presenter.onAddToLocalButtonClickedMessage)
    )
    .introspectTabBarController { controller in
      tabBar = controller.tabBar
      tabBar?.layer.zPosition = -1
      tabBar?.isUserInteractionEnabled = false
    }
    .introspectNavigationController { controller in
      navigationBar = controller.navigationBar
      navigationBar?.tintColor = isOpaqueNavigationBar ? .purple : .white
    }
  }
}

// MARK: - Recipe Image
extension RecipeDetailView {
  private var defaultRecipeImageHeight: CGFloat {
    UIScreen.main.bounds.height / 2.2
  }
  
  private func recipeImageframeHeight(
    geometry: GeometryProxy
  ) -> CGFloat {
    return geometry.frame(in: .global).minY > 0 ?
      geometry.frame(in: .global).minY + defaultRecipeImageHeight :
      defaultRecipeImageHeight
  }
  
  private var headerImage: some View {
    GeometryReader { geometry in
      VStack {
        WebImage(url: URL(string: presenter.dataModel.image))
          .resizable()
          .indicator(.activity)
          .transition(.fade(duration: 0.5))
          .aspectRatio(contentMode: .fill)
          .frame(
            width: UIScreen.main.bounds.width,
            height: recipeImageframeHeight(geometry: geometry)
          )
          .offset(y: -geometry.frame(in: .global).minY)
          .onChange(of: geometry.frame(in: .global).minY) { value in
            isOpaqueNavigationBar = value < -7.0
          }
      }
    }
    .frame(height: defaultRecipeImageHeight)
  }
}

// MARK: - Caloric Breakdown (Protein, Fat, Carbs)
extension RecipeDetailView {
  private var caloricBreakDownView: some View {
    HStack(alignment: .center, spacing: 20) {
      caloricBreakDownItem(
        for: "protein",
        with: presenter.dataModel.caloricBreakdown.protein
      )
      caloricBreakDownItem(
        for: "fat",
        with: presenter.dataModel.caloricBreakdown.fat
      )
      caloricBreakDownItem(
        for: "carbs",
        with: presenter.dataModel.caloricBreakdown.carbs
      )
    }
  }
  
  private func caloricBreakDownItem(
    for name: String,
    with percent: Float
  ) -> some View {
    VStack(spacing: 12.0) {
      RingView(
        width: 44,
        height: 44,
        number: CGFloat(percent)
      )
      Text(name.uppercased())
        .font(.caption)
    }
    .padding()
    .background(Color.white)
    .cornerRadius(20)
    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 6)
    .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
  }
}

// MARK: - Favorite Button
extension RecipeDetailView {
  private var bookmarkImageSystemName: String {
    presenter.dataModelIsInLocalDB ?
      "bookmark.fill" :
      "bookmark"
  }
  
  private var clearNavigationBarFavoriteIcon: some View {
    Image(systemName: bookmarkImageSystemName)
      .foregroundColor(.white)
      .font(.system(size: 15, weight: .bold))
      .frame(width: 25, height: 25)
      .padding(3)
      .background(Color.black.opacity(0.15))
      .clipShape(Circle())
  }
  
  private var opaqueNavigationBarFavoriteIcon: some View {
    Image(systemName: bookmarkImageSystemName)
      .foregroundColor(Color(UIColor.purple))
  }
  
  var favoriteButtonLabel: AnyView {
    isOpaqueNavigationBar ?
      AnyView(opaqueNavigationBarFavoriteIcon) :
      AnyView(clearNavigationBarFavoriteIcon)
  }
}
