//
//  LoadingView.swift
//  Apple Watch ArUco
//
//  Created by Yunho Cho on 3/15/25.
//

import SwiftUI

struct LoadingView: View {
  var onNext: () -> Void
  var loadTime: Int = 1
  
  var body: some View {
    VStack {
      Text("Loading...").font(.title)
      Text("Swipe left to adjust settings.")
    }
    .onAppear {
      // Schedule the next screen transition after loadTime seconds
      DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(loadTime)) {
        onNext()
      }
    }
  }
}

#Preview {
  LoadingView(onNext: {})
}
