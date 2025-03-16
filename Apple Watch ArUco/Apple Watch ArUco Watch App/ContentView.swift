//
//  ContentView.swift
//  Apple Watch ArUco Watch App
//
//  Created by Yunho Cho on 3/15/25.
//

import SwiftUI

// Example usage with a predefined 4x4 marker
struct ContentView: View {
  @State private var currentScreen: ScreenType = .selection
  
  enum ScreenType {
    case selection
    case loading
    case marker
  }
  
  let sampleMarker = [
    [1, 1, 1, 1],
    [1, 0, 1, 0],
    [0, 1, 0, 1],
    [1, 1, 1, 1]
  ]

  var body: some View {
    switch currentScreen {
    case .selection:
      SelectionView()
    case .loading:
      LoadingView()
    case .marker:
      ArucoMarkerView(markerSize: 4, markerId: 0, markerData: sampleMarker)
        .frame(width: 200, height: 200)
    }
  }
}

#Preview {
  ContentView()
}
