import Foundation
import SwiftData

@Model
class HelpRequestModel: Identifiable, Encodable, Decodable{
    var id: String
    var timestamps: Date
    var name: String
    var location: String
    var detailLocation: String
    var vehicle: VehicleModel
    
    init(timestamps: Date, name: String, location: String, detailLocation: String, vehicle: VehicleModel) {
        self.id = UUID().uuidString
        self.timestamps = timestamps
        self.name = name
        self.location = location
        self.detailLocation = detailLocation
        self.vehicle = vehicle
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        let timestamp = try container.decode(Double.self, forKey: .timestamps)
        timestamps = Date(timeIntervalSince1970: timestamp)
        name = try container.decode(String.self, forKey: .name)
        location = try container.decode(String.self, forKey: .location)
        detailLocation = try container.decode(String.self, forKey: .detailLocation)
        vehicle = try container.decode(VehicleModel.self, forKey: .vehicle)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(timestamps.timeIntervalSince1970, forKey: .timestamps)  // Encoding as a timestamp
        try container.encode(name, forKey: .name)
        try container.encode(location, forKey: .location)
        try container.encode(detailLocation, forKey: .detailLocation)
        try container.encode(vehicle, forKey: .vehicle)
    }
        
    enum CodingKeys: String, CodingKey {
        case id
        case timestamps
        case name
        case location
        case detailLocation
        case vehicle
    }
}

extension Encodable {
    var helpRequestToDictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
    }
}
