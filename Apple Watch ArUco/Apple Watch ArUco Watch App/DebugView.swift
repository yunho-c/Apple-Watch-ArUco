//
//  DebugView.swift
//  Apple Watch ArUco
//
//  Created by Yunho Cho on 3/16/25.
//

import SwiftUI

struct DebugView: View {
  let service = ArucoDictFetchService()
//  var data: Any? {
  var data: Any! {
    return try? service.loadJSON(fileName: "aruco_dict_4x4_100")
  }
  
  var body: some View {
    VStack {
      Text("Debug View")
      Button("Load JSON") {
        do {
          data
          print(data)
        } catch {
          // pass
        }
      }
      .buttonStyle(.borderedProminent)
    }
  }
}

#Preview {
  DebugView()
}
