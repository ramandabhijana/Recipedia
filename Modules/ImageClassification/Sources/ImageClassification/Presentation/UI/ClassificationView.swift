//
//  ClassificationView.swift
//  Recipedia
//
//  Created by Abhijana Agung Ramanda on 17/01/21.
//

import SwiftUI
import Core
import typealias Recipe.HomePresenter
import class PhotosUI.PHPickerViewController

public struct ClassificationView: View {
  @ObservedObject var presenter: GetClassificationPresenter
  @State private var showingAlert = true
  @State private var showingPhotoPicker = true
  @EnvironmentObject var homePresenter: HomePresenter
  
  public init(presenter: GetClassificationPresenter) {
    self.presenter = presenter
  }
  
  public var body: some View {
    ZStack {
      Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all)
      switch presenter.state {
      case .empty:
        Button(
          action: { showingPhotoPicker.toggle() },
          label: { uploadButtonLabel }
        )
      case .loading:
        VStack {
          ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
            .frame(width: 50, height: 50)
          Text("Let me see...")
            .fontWeight(.light)
            .font(.footnote)
        }
        .frame(width: 100, height: 100)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
      case .error(let message):
          makeErrorView(with: message)
      case .populated:
        if let model = presenter.dataModel {
          VStack {
            Image(uiImage: presenter.image ?? .remove)
              .resizable()
              .frame(height: 200)
            Spacer()
          }
          .alert(isPresented: $showingAlert) {
            model.isConfident ? confidentAlert(with: model) : vagueAlert(with: model)
          }
        }
      }
    }
    .sheet(isPresented: $showingPhotoPicker) {
      PHPickerViewController.View(image: $presenter.image)
    }
    .navigationTitle("Visual Search")
  }
}

extension ClassificationView {
  fileprivate func confidentAlert(with model: ClassificationDomainModel) -> Alert {
    Alert(
      title: Text("GOTCHA! 🙌🏼"),
      message: Text("It's a \(model.formattedCategory)"),
      dismissButton: .default(Text("Search")) {
        homePresenter.setRequest(.name(model.category))
        homePresenter.isSearching.toggle()
      }
    )
  }
  
  fileprivate func vagueAlert(with model: ClassificationDomainModel) -> Alert {
    Alert(
      title: Text("Hmm..."),
      message: Text("I'm not sure about this.\nIs this \(model.formattedCategory)?"),
      primaryButton: .default(Text("Yes")) {
        homePresenter.setRequest(.name(model.category))
        homePresenter.isSearching.toggle()
      },
      secondaryButton: .cancel(Text("Cancel")) {
        homePresenter.isSearching.toggle()
      }
    )
  }
  
  private var uploadButtonLabel: some View {
    Circle()
      .frame(width: 150, height: 150)
      .foregroundColor(Color.purple.opacity(0.5))
      .shadow(
        color: Color.purple,
        radius: 10, x: 10, y: 20
      )
      .overlay(
        Image(systemName: "square.and.arrow.up")
          .font(.system(size: 80))
          .foregroundColor(Color(#colorLiteral(red: 0.5071844769, green: 0, blue: 0.8548211618, alpha: 1)))
      )
  }
}
