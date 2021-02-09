//
//  AuthorView.swift
//  Recipedia
//
//  Created by Abhijana Agung Ramanda on 01/02/21.
//

import SwiftUI

struct AuthorView: View {
  var body: some View {
    NavigationView {
      VStack {
        authorPhoto
          .padding(.vertical)
        authorName
          .padding(.bottom)
        
        List {
          Section(header: Text("Contact")) {
            Label {
              Text("abhijanaramanda@gmail.com")
            } icon: {
              Image(systemName: "envelope")
                .foregroundColor(.purple)
            }
            Label {
              Text("+62-877-6181-8325")
            } icon: {
              Image(systemName: "phone")
                .foregroundColor(.purple)
            }
          }
          Section(header: Text("Favorite food")) {
            Text("Fried Chicken")
          }
        }
        .listStyle(InsetGroupedListStyle())
        
      }
      .navigationBarTitle(
        Text("Profile"),
        displayMode: .automatic
      )
    }
  }
}

struct AuthorView_Previews: PreviewProvider {
  static var previews: some View {
    AuthorView()
  }
}

extension AuthorView {
  private var authorPhoto: some View {
    Image("ProfilePicture")
      .renderingMode(.original)
      .resizable()
      .aspectRatio(contentMode: .fill)
      .frame(width: 120, height: 120)
      .clipShape(Circle())
      .shadow(
        color: Color.black.opacity(0.1),
        radius: 1, x: 0, y: 1
      )
      .shadow(
        color: Color.black.opacity(0.2),
        radius: 10, x: 0, y: 10
      )
  }
  
  private var authorName: some View {
    VStack {
      Text("Hello there, I'm")
        .font(.callout)
        .fontWeight(.light)
        .foregroundColor(.gray)
      Text("Abhijana Agung Ramanda")
        .font(.title3)
    }
  }
}
