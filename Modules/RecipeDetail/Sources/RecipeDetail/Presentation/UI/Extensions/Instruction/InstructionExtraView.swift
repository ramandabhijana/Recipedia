//
//  InstructionExtraView.swift
//  Recipedia
//
//  Created by Abhijana Agung Ramanda on 14/11/20.
//

import SwiftUI
import SDWebImageSwiftUI
import typealias Recipe.HomePresenter

/// This View contains list of Ingredients or Equipments of specific Recipe's Instruction
public struct InstructionMiscView: View {
  var presenter: GetInstructionMiscPresenter
  @Environment(\.presentationMode) private var presentationMode
  
  public var body: some View {
    NavigationView {
      List(presenter.getList(), id: \.identifier) {
        makeRow(for: $0)
      }
      .listStyle(InsetGroupedListStyle())
      .navigationBarTitle(
        presenter.listTitle,
        displayMode: .large
      )
      .navigationBarItems(
        trailing: Button(
          action: { presentationMode.wrappedValue.dismiss() },
          label: { Text("Done") }
        )
        .foregroundColor(Color(.purple))
      )
    }
  }
}

extension InstructionMiscView {
  func makeRow(for item: InstructionMisc) -> some View {
    HStack {
      WebImage(url: item.image)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 50, height: 50)
      Text(item.name)
        .foregroundColor(.black)
    }
  }
}
