//
//  MinorModel.swift
//  Geber for Staff
//
//  Created by Vikri Yuwi on 20/11/24.
//
import SwiftData

class MinorModel: Identifiable, Codable {
    var id: Int
    var detailLocation: String
    
    init(id: Int, detailLocation: String) {
        self.id = id
        self.detailLocation = detailLocation
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        detailLocation = try container.decode(String.self, forKey: .detailLocation)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(detailLocation, forKey: .detailLocation)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case detailLocation
    }
}
