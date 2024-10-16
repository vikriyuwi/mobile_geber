import Foundation
import SwiftData

@Model
class HelpRequestModel: Identifiable, Encodable {
    var id: String
    var timestamps: Date
    var name: String
    var location: String
    var detailLocation: String
    
    init(timestamps: Date, name: String, location: String, detailLocation: String) {
        self.id = UUID().uuidString
        self.timestamps = timestamps
        self.name = name
        self.location = location
        self.detailLocation = detailLocation
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(timestamps.timeIntervalSince1970, forKey: .timestamp)  // Encoding as a timestamp
        try container.encode(name, forKey: .name)
    }
        
    enum CodingKeys: String, CodingKey {
        case id
        case timestamp
        case name
    }
}
