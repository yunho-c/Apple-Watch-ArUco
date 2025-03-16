//
//  ArucoDictFetchService.swift
//  Apple Watch ArUco
//
//  Created by Yunho Cho on 3/16/25.
//

import Foundation

class ArucoDictFetchService {
    // Basic JSON parsing from a file
    func loadJSON(fileName: String) throws -> Any {
        guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            throw NSError(domain: "JSONError", code: 404, userInfo: [NSLocalizedDescriptionKey: "File not found"])
        }
        
        let jsonData = try Data(contentsOf: fileURL)
        return try JSONSerialization.jsonObject(with: jsonData)
    }
  
//    func getMarkerPattern(for id: Int) -> [[Int]]? {
//        
//    }
}
