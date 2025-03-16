//
//  ArucoDictFetchService.swift
//  Apple Watch ArUco
//
//  Created by Yunho Cho on 3/16/25.
//

import Foundation

struct ArUcoDictionary: Codable {
    let nmarkers: Int
    let markersize: Int
    let maxCorrectionBits: Int
    let markers: [String]
    
    // Custom keys for decoding
    private enum CodingKeys: String, CodingKey {
        case nmarkers
        case markersize
        case maxCorrectionBits
        // We'll handle marker_X keys manually
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        
        // Decode fixed fields
        nmarkers = try container.decode(Int.self, forKey: DynamicCodingKeys(stringValue: "nmarkers")!)
        markersize = try container.decode(Int.self, forKey: DynamicCodingKeys(stringValue: "markersize")!)
        maxCorrectionBits = try container.decode(Int.self, forKey: DynamicCodingKeys(stringValue: "maxCorrectionBits")!)
        
        // Extract all marker_X keys
        var tempMarkers: [Int: String] = [:]
        
        for key in container.allKeys {
            let keyString = key.stringValue
            if keyString.hasPrefix("marker_") {
                // Extract the marker index from key (marker_X)
                if let indexStr = keyString.split(separator: "_").last,
                   let index = Int(indexStr) {
                    tempMarkers[index] = try container.decode(String.self, forKey: key)
                }
            }
        }
        
        // Sort markers by index and extract just the values
        markers = tempMarkers.sorted { $0.key < $1.key }.map { $0.value }
        
        // Verify we have the expected number of markers
        guard markers.count == nmarkers else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Expected \(nmarkers) markers but found \(markers.count)"
                )
            )
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        
        // Encode fixed fields
        try container.encode(nmarkers, forKey: DynamicCodingKeys(stringValue: "nmarkers")!)
        try container.encode(markersize, forKey: DynamicCodingKeys(stringValue: "markersize")!)
        try container.encode(maxCorrectionBits, forKey: DynamicCodingKeys(stringValue: "maxCorrectionBits")!)
        
        // Encode dynamic marker fields
        for (index, marker) in markers.enumerated() {
            let key = DynamicCodingKeys(stringValue: "marker_\(index)")!
            try container.encode(marker, forKey: key)
        }
    }
    
    // Helper struct for dynamic coding keys
    private struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        var intValue: Int?
        
        init?(stringValue: String) {
            self.stringValue = stringValue
            self.intValue = nil
        }
        
        init?(intValue: Int) {
            self.stringValue = "\(intValue)"
            self.intValue = intValue
        }
    }
}

// Extension to convert binary string to actual marker data
extension ArUcoDictionary {
    func getBinaryMarker(at index: Int) -> [[Int]]? {
        guard index >= 0 && index < markers.count else { return nil }
        
        let markerString = markers[index]
        let size = Int(sqrt(Double(markerString.count)))
        
        // Check if the marker string has a valid square size
        guard size * size == markerString.count else { return nil }
        
        var markerData = Array(repeating: Array(repeating: 0, count: size), count: size)
        
        for (i, char) in markerString.enumerated() {
            let row = i / size
            let col = i % size
            markerData[row][col] = char == "1" ? 1 : 0
        }
        
        return markerData
    }
}

class ArucoDictFetchService {
  func loadJSON(fileName: String) throws -> Any {
      guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: "json") else {
          throw NSError(domain: "JSONError", code: 404, userInfo: [NSLocalizedDescriptionKey: "File not found"])
      }
      
      let jsonData = try Data(contentsOf: fileURL)
      return try JSONSerialization.jsonObject(with: jsonData)
  }
  
  func loadArucoDictionary(fileName: String) throws -> ArUcoDictionary {
      guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: "json") else {
          throw NSError(domain: "JSONError", code: 404, userInfo: [NSLocalizedDescriptionKey: "File not found"])
      }
      let jsonData = try Data(contentsOf: fileURL)
      let dictionary = try JSONDecoder().decode(ArUcoDictionary.self, from: jsonData)
      return dictionary
    }
}

