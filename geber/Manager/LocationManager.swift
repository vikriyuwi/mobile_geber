import SwiftUI
import CoreLocation

class LocationManager: NSObject, LocationManagerProtocol, ObservableObject, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager = CLLocationManager()
    private let realtimeDatabaseService = RealtimeDatabaseService.shared
    
    public let beaconUUID = UUID(uuidString: "EF63C140-2AF4-4E1E-AAB3-340055B3BB4B")!
    public var beaconLocations: [BeaconModel] = []
    @Published var currentNearestLocation: BeaconModel? = nil
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
    }
    
    func startScanning() {
        stopScanning()
        observeMajorsToBeaconLocations { [weak self] in
            guard let self = self else { return }
            
            for beaconLocation in self.beaconLocations {
                guard let beaconUUID = UUID(uuidString: beaconLocation.identifier) else { continue }
                
                let constraint = CLBeaconIdentityConstraint(uuid: beaconUUID)
                let beaconRegion = CLBeaconRegion(beaconIdentityConstraint: constraint, identifier: beaconLocation.identifier)
                
                self.locationManager.startMonitoring(for: beaconRegion)
                self.locationManager.startRangingBeacons(satisfying: constraint)
            }
        }
    }
    
    func stopScanning() {
        for region in locationManager.monitoredRegions {
            if let beaconRegion = region as? CLBeaconRegion {
                locationManager.stopMonitoring(for: beaconRegion)
            }
        }
        
        for constraint in locationManager.rangedBeaconConstraints {
            locationManager.stopRangingBeacons(satisfying: constraint)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying constraint: CLBeaconIdentityConstraint) {
        
        guard !beacons.isEmpty else {
            currentNearestLocation = nil
            return
        }
        
        guard let foundBeacon = beacons.first, foundBeacon.rssi < 0 else {
            currentNearestLocation = nil
            return
        }
        
        if let location = beaconLocations.first(where: {
            $0.identifier == foundBeacon.uuid.uuidString &&
            $0.major == foundBeacon.major.intValue &&
            $0.minor == foundBeacon.minor.intValue
        }) {
            location.rssi = foundBeacon.rssi
            
            if currentNearestLocation == nil || (currentNearestLocation?.rssi ?? Int.min) < location.rssi {
                currentNearestLocation = location
            }
        }
    }
}

extension LocationManager {
    func observeMajorsToBeaconLocations(completion: @escaping () -> Void) {
        realtimeDatabaseService.observeData(path: "majors") { [weak self] (result: Result<[MajorModel], Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let majors):
                    self.beaconLocations = majors.flatMap { major in
                        major.minors.map { minor in
                            BeaconModel(
                                identifier: self.beaconUUID.uuidString,
                                major: major.id,
                                minor: minor.id,
                                location: major.location,
                                detailLocation: minor.detailLocation
                            )
                        }
                    }
                case .failure(let error):
                    print("Error fetching data: \(error.localizedDescription)")
                }
                completion()
            }
        }
    }
}
