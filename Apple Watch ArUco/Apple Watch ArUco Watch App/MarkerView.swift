//
//  MarkerView.swift
//  Apple Watch ArUco
//
//  Created by Yunho Cho on 3/15/25.
//

import SwiftUI

struct ArucoMarkerView: View {
    let markerSize: Int
    let markerData: [[Int]] // The binary pattern of the marker
    let marginSize: Int = 2

    var body: some View {
        GeometryReader { geometry in
            let cellSize = geometry.size.width / CGFloat(markerSize + 2*marginSize)
//            let effectiveCellSize = cellSize + 2 // including margin
            Canvas { context, size in
              for row in -marginSize..<markerSize+marginSize {
                  for col in -marginSize..<markerSize+marginSize {
                    let rect = CGRect(
                      x: CGFloat(col + marginSize) * cellSize,
                      y: CGFloat(row + marginSize) * cellSize,
                      width: cellSize,
                      height: cellSize
                    )
                    if row == -2 || row == markerSize+1 || col == -2 || col == markerSize+1 {
                      context.fill(Path(rect), with: .color(.white))
                    }
                    else if row == -1 || row == markerSize || col == -1 || col == markerSize {
                      context.fill(Path(rect), with: .color(.black))
                    }
                  }
                }
                for row in 0..<markerSize {
                  for col in 0..<markerSize {
                    let rect = CGRect(
                      x: CGFloat(col + marginSize) * cellSize,
                      y: CGFloat(row + marginSize) * cellSize,
                      width: cellSize,
                      height: cellSize
                    )
                    if markerData[row][col] == 1 {
                      context.fill(Path(rect), with: .color(.white))
                    }
                    else if markerData[row][col] == 0 {
                      context.fill(Path(rect), with: .color(.black))
                    }
                  }
                }
            }
//            .background(Color.white)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

// Example usage with a predefined 4x4 marker
struct ArucoMarkerTestView: View {
    let sampleMarker = [
        [1, 1, 1, 1],
        [1, 0, 1, 0],
        [0, 1, 0, 1],
        [1, 1, 1, 1]
    ]

    var body: some View {
        ArucoMarkerView(markerSize: 4, markerData: sampleMarker)
            .frame(width: 200, height: 200)
    }
}

#Preview {
  ArucoMarkerTestView()
}
