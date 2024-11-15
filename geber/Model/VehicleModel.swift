//
//  VehicleModel.swift
//  geber
//
//  Created by Vikri Yuwi on 2/10/24.
//
import Foundation
import SwiftData

@Model
class VehicleModel: Identifiable, Encodable, Decodable {
    var model: String
    @Attribute(.unique) var plateNumber: String
    var color: String
    init(model: String, plateNumber: String, color: String) {
        self.model = model
        self.plateNumber = plateNumber
        self.color = color
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        model = try container.decode(String.self, forKey: .model)
        plateNumber = try container.decode(String.self, forKey: .plateNumber)
        color = try container.decode(String.self, forKey: .color)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(model, forKey: .model)
        try container.encode(plateNumber, forKey: .plateNumber)
        try container.encode(color, forKey: .color)
    }
        
    enum CodingKeys: String, CodingKey {
        case model
        case plateNumber
        case color
    }
}

extension Encodable {
    var vehicleToDictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
    }
}
