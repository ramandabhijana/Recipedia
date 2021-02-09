//
//  QuotaSheetView.swift
//  Recipedia
//
//  Created by Abhijana Agung Ramanda on 26/11/20.
//

import SwiftUI

extension RemoteRecipesView {
  
  var quotaUsedSheetView: some View {
    VStack(alignment: .leading, spacing: 20) {
      Rectangle()
        .frame(width: 40, height: 5)
        .cornerRadius(3)
        .opacity(0.3)
        .frame(maxWidth: .infinity, alignment: .center)
      Text("The amount of quota that you've used.")
        .font(.title3)
        .fontWeight(.bold)
        .foregroundColor(.black)
      Text("""
Its amount will increase every time you browse on this Home page.
Once it has reached 150, you will no longer be able to see or search for recipes other than those in your Favorite list
"""
      )
      .font(.subheadline)
      .lineSpacing(4)
    }
    .frame(maxWidth: .infinity)
    .padding()
    .padding(.bottom, 20)
    .background(Color(UIColor.systemBackground))
  }
}
