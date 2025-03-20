//
//  SelectionView.swift
//  Apple Watch ArUco
//
//  Created by Yunho Cho on 3/15/25.
//

// NOTE: not sure if state is better tracked in individual Views
//       or comprehensively in the SelectionView widget.
//       also not sure how view changes are done in SwiftUI. 

//       since this is a super tiny app, let's just track all states
//       outside, in the ContentView widget. and let's remove the
//       selectionview wrapper, insteading using the two screens directly.

import SwiftUI

struct ArucoDictionarySelectionView: View {
  @Binding var selectedDict: String
  let arucoDicts = ["4x4", "5x5", "6x6", "7x7"]
  var onNext: () -> Void
  
  var body: some View {
    VStack {
      Picker("Marker Size", selection: $selectedDict) {
        ForEach(arucoDicts, id: \.self) { dict in
            Text(dict).tag(dict) // NOTE: not sure if `.tag()` is necessary here
          }
      }
      .onAppear {
        selectedDict = arucoDicts[0]
      }
      .padding()
      Button("Next")
           {
             onNext()
           }
           .buttonStyle(DefaultButtonStyle())
           .foregroundStyle(Color.blue)
    }
  }
}

struct ArucoIdSelectionView: View {
  @Binding var selectedId: Int
  let maxIdValue: Int = 100
  var onNext: () -> Void
  var onBack: () -> Void
  
  var body: some View {
    VStack {
      Picker("ArUco ID", selection: $selectedId) {
          ForEach(0..<maxIdValue) { id in
            Text("\(id)").tag(id)
          }
      }
      .padding()
      // NOTE: let's consider putting the back/next buttons side-by-side.
//      Button("Back")
//           {
//             onBack()
//           }
//           .buttonStyle(DefaultButtonStyle())
//           .foregroundStyle(Color.secondary)
      Button("Next")
           {
             onNext()
           }
           .buttonStyle(DefaultButtonStyle())
           .foregroundStyle(Color.blue)
    }
  }
}

//struct SelectionView: View {
//  @State private var currentScreen = 0
//  @State var selectedDict = "" // may have to late-initialize?
//  @State var idValue = 0
//  
////  @State private var preferences = UserPreferences()
//
//  var body: some View {
//    if currentScreen == 0 {
//      ArucoDictionarySelectionView(
//        selectedDict: $selectedDict,
//        onNext: { currentScreen = 1 }
//      )
//    } else {
//      ArucoIdSelectionView(
//        idValue: $idValue,
//        onNext: { currentScreen = 2 },
//        onBack: { currentScreen = 0 }
////        onComplete: saveAndFinishOnboarding
//      )
//    }
//  }
//  
//  func saveAndFinishOnboarding() {
//      // Save preferences and exit onboarding
//  }
//}

//#Preview {
//  SelectionView()
//}
