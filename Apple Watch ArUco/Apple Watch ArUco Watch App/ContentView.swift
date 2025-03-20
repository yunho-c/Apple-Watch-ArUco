//
//  ContentView.swift
//  Apple Watch ArUco Watch App
//
//  Created by Yunho Cho on 3/15/25.
//

import SwiftUI

// Example usage with a predefined 4x4 marker
struct ContentView: View {
  // state management
//  @State private var currentScreen: ScreenType = .main // TODO implement a fancy attractive main screen
  @State private var currentScreen: ScreenType = .selection_dict
  @State private var dragOffset: CGFloat = 0 // offset state for drag visualization

  // data
  @State var selectedDict = "" // DEBUG // may have to late-initialize? this seems awkward.
  @State var selectedId = 0
  var arucoDictData: ArUcoDictionary! {
    return try? ArucoDictFetchService().loadArucoDictionary(fileName: "aruco_dict_\(selectedDict)_100")
  }
  
  var dragSize = 20.0;
  
  enum ScreenType {
//    case splash
    case main
    case selection_dict
    case selection_id
    case loading
    case marker
  }
  
  // Simple function to return the previous screen based on current screen
  private func previousScreen(for current: ScreenType) -> ScreenType? {
    switch current {
    case .selection_id: return .selection_dict
    case .loading: return .selection_id
    case .marker: return .selection_id
    default: return nil // No previous screen for main and selection_dict
    }
  }
  
  var body: some View {
    let content = Group {
      switch currentScreen {
      case .main:
        Text("Not Implemented")
      case .selection_dict:
        ArucoDictionarySelectionView(selectedDict: $selectedDict, onNext: { currentScreen = .selection_id })
      case .selection_id:
        ArucoIdSelectionView(selectedId: $selectedId, onNext: { currentScreen = .loading }, onBack: { currentScreen = .selection_dict })
      case .loading:
        VStack {
          LoadingView(onNext: { currentScreen = .marker })
          // DEBUG
          Text("") // newline
          Text("Dict: \(selectedDict)").font(.caption2)
          Text("ID: \(selectedId)").font(.caption2)
        }
      case .marker:
        ArucoMarkerView(markerSize: arucoDictData.markersize, markerId: selectedId, markerData: arucoDictData.getBinaryMarker(at: selectedId)!)
          .frame(width: 200, height: 200)
      }
    }
    
    return content
      .offset(x: dragOffset)
      .gesture(
        DragGesture(minimumDistance: 15)
          .onChanged { value in
            // Only allow right swipe if there's a previous screen
            if value.translation.width > 0 && previousScreen(for: currentScreen) != nil {
              // Apply some resistance to the drag
              dragOffset = value.translation.width * 0.6
            }
          }
          .onEnded { value in
            dragOffset = 0
            // Check if swipe is primarily horizontal and right-to-left
            if value.translation.width > dragSize && abs(value.translation.height) < dragSize {
              if let previous = previousScreen(for: currentScreen) {
                withAnimation {
                  currentScreen = previous
                }
              }
            }
          }
      )
  }
}

#Preview {
  ContentView()
}
