//
//  RingView.swift
//  Recipedia
//
//  Created by Abhijana Agung Ramanda on 13/11/20.
//

import SwiftUI

struct RingView: View {
  var color = #colorLiteral(red: 0.0431372549, green: 0.5176470588, blue: 0.3411764706, alpha: 1)
  var width: CGFloat = 88
  var height: CGFloat = 88
  var number: CGFloat
  
  var body: some View {
    let multiplier = width / 44
    return ZStack {
      background(with: multiplier)
      circularProgressBar(with: multiplier)
      Text("\(Int(number))g")
        .font(.system(size: 14 * multiplier))
        .fontWeight(.bold)
    }
  }
}

struct RingView_Previews: PreviewProvider {
  static var previews: some View {
    RingView(number: 97)
  }
}

extension RingView {
  fileprivate func background(
    with multiplier: CGFloat
  ) -> some View {
    Circle()
      .stroke(
        Color.black.opacity(0.1),
        style: StrokeStyle(lineWidth: 5 * multiplier)
      )
      .frame(width: width, height: height)
  }
  
  fileprivate func circularProgressBar(
    with multiplier: CGFloat
  ) -> some View {
    let progress = 1 - (number / 100)
    return Circle()
      .trim(from: progress, to: 1)
      .stroke(
        Color(color),
        style: StrokeStyle(
          lineWidth: 5 * multiplier,
          lineCap: .round,
          lineJoin: .round,
          miterLimit: .infinity,
          dash: [20, 0],
          dashPhase: 0
        )
      )
      .rotationEffect(Angle(degrees: 90))
      .rotation3DEffect(
        Angle(degrees: 180),
        axis: (x: 1, y: 0, z: 0)
      )
      .frame(width: width, height: height)
      .shadow(
        color: Color.black.opacity(0.1),
        radius: 3 * multiplier, x: 0, y: 3 * multiplier
      )
  }
  
}
