//
//  MarkerView.swift
//  Apple Watch ArUco
//
//  Created by Yunho Cho on 3/15/25.
//

import SwiftUI

struct ArucoMarkerView: View {
    let markerSize: Int
    let markerId: Int
    let markerData: [[Int]] // The binary pattern of the marker
    let marginSize: Int = 2
    let cornerRadius: CGFloat = 25 // Adjust this value to change the roundness of the corners

    var body: some View {
      VStack {
//        Text("ID: \(markerId)").font(.caption2)
        GeometryReader { geometry in
          let cellSize = geometry.size.width / CGFloat(markerSize + 2*marginSize)
          Canvas { context, size in
            // Draw all cells
            for row in -marginSize..<markerSize+marginSize {
              for col in -marginSize..<markerSize+marginSize {
                let rect = CGRect(
                  x: CGFloat(col + marginSize) * cellSize,
                  y: CGFloat(row + marginSize) * cellSize,
                  width: cellSize,
                  height: cellSize
                )
                
                // Determine if this is a corner cell in the white margin
                let isCorner = (row == -2 && col == -2) || // Top-left
                (row == -2 && col == markerSize+1) || // Top-right
                (row == markerSize+1 && col == -2) || // Bottom-left
                (row == markerSize+1 && col == markerSize+1) // Bottom-right
                
                if row == -2 || row == markerSize+1 || col == -2 || col == markerSize+1 {
                  if isCorner {
                    // Create a rounded path for corner cells
                    let cornerPath = createRoundedCornerPath(rect: rect, corner: (row, col), cellSize: cellSize, markerSize: markerSize)
                    context.fill(cornerPath, with: .color(.white))
                  } else {
                    // Regular white margin cells
                    context.fill(Path(rect), with: .color(.white))
                  }
                }
                else if row == -1 || row == markerSize || col == -1 || col == markerSize {
                  // Black border cells
                  context.fill(Path(rect), with: .color(.black))
                }
              }
            }
            
            // Draw marker data cells
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
        }
      }
        .aspectRatio(1, contentMode: .fit)
    }
    
    // Helper function to create rounded corner paths
    private func createRoundedCornerPath(rect: CGRect, corner: (Int, Int), cellSize: CGFloat, markerSize: Int) -> Path {
        var path = Path()
        
        // Determine which corner this is and create the appropriate rounded corner
        switch corner {
        case (-2, -2): // Top-left corner
            path.move(to: CGPoint(x: rect.minX + cornerRadius, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius))
            path.addArc(center: CGPoint(x: rect.minX + cornerRadius, y: rect.minY + cornerRadius),
                        radius: cornerRadius,
                        startAngle: .degrees(180),
                        endAngle: .degrees(270),
                        clockwise: false)
            
        case (-2, markerSize+1): // Top-right corner
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY))
            path.addArc(center: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY + cornerRadius),
                        radius: cornerRadius,
                        startAngle: .degrees(270),
                        endAngle: .degrees(0),
                        clockwise: false)
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            
        case (markerSize+1, -2): // Bottom-left corner
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY))
            path.addArc(center: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY - cornerRadius),
                        radius: cornerRadius,
                        startAngle: .degrees(90),
                        endAngle: .degrees(180),
                        clockwise: false)
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
            
        case (markerSize+1, markerSize+1): // Bottom-right corner
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius))
            path.addArc(center: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY - cornerRadius),
                        radius: cornerRadius,
                        startAngle: .degrees(0),
                        endAngle: .degrees(90),
                        clockwise: false)
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            
        default:
            // This should never happen with the current implementation
            path = Path(rect)
        }
        
        return path
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
      ArucoMarkerView(markerSize: 4, markerId: 0, markerData: sampleMarker)
            .frame(width: 200, height: 200)
    }
}

#Preview {
  ArucoMarkerTestView()
}
