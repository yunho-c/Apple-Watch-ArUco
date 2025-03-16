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
  
  // data
  // @State var selectedDict = "0" // may have to late-initialize? this seems awkward.
  @State var selectedDict = "" // DEBUG // may have to late-initialize? this seems awkward.
  @State var selectedId = 0
  var arucoDictData: ArUcoDictionary! {
    return try? ArucoDictFetchService().loadArucoDictionary(fileName: "aruco_dict_\(selectedDict)_100")
  }
  
  enum ScreenType {
//    case splash
    case main
    case selection_dict
    case selection_id
    case loading
    case marker
  }
  
  var body: some View {
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
        Text("ArUco Dict: \(selectedDict)").font(.caption2)
        Text("ArUco ID: \(selectedId)").font(.caption2)
      }
    case .marker:
      ArucoMarkerView(markerSize: arucoDictData.markersize, markerId: selectedId, markerData: arucoDictData.getBinaryMarker(at: selectedId)!)
        .frame(width: 200, height: 200)
    }
  }
}

#Preview {
  ContentView()
}
