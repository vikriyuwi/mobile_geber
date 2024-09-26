import Foundation
import CoreLocation

class BeaconModel: Identifiable {
    var identifier:String
    var major:Int
    var minor:Int
    var location:String
    var detailLocation:String
    var proximity: CLProximity = .unknown
    var rssi: Int = 0
    var accuracy: CLLocationAccuracy = 0
    
    init(identifier: String, major: Int, minor: Int, location: String, detailLocation: String) {
        self.identifier = identifier
        self.major = major
        self.minor = minor
        self.location = location
        self.detailLocation = detailLocation
    }
}
