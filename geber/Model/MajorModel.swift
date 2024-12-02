//
//  MajorModel.swift
//  Geber for Staff
//
//  Created by Vikri Yuwi on 20/11/24.
//

import SwiftData

class MajorModel: Identifiable, Codable {
    var id: Int
    var location: String
    var minors: [MinorModel]
    
    init (id: Int, location: String, minor: [MinorModel]) {
        self.id = id
        self.location = location
        self.minors = minor
    }
    
    required init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        location = try container.decode(String.self, forKey: .location)

        // Try decoding minors as an array first, then fallback to a dictionary
        if let minorsArray = try? container.decode([MinorModel?].self, forKey: .minors) {
            // Filter out `nil` values from the array
            minors = minorsArray.compactMap { $0 }
        } else if let minorsDict = try? container.decode([String: MinorModel].self, forKey: .minors) {
            minors = minorsDict.map { $0.value }
        } else {
            minors = []
        }
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(location, forKey: .location)
        try container.encode(minors, forKey: .minors)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case location
        case minors
    }
}
