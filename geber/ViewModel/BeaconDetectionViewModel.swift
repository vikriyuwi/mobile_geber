//
//  BeaconDetectionViewModel.swift
//  geber
//
//  Created by Vikri Yuwi on 25/9/24.
//

import Foundation
import CoreLocation
import Combine

class BeaconDetectionViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var locationManager: CLLocationManager?
    @Published var currentNearestLocation: BeaconModel? = nil
    
    var beaconLocations: [BeaconModel] = [
        BeaconModel(identifier: "EF63C140-2AF4-4E1E-AAB3-340055B3BB4B", major: 0, minor: 0, location: "S01", detailLocation: "A01-A05"),
        BeaconModel(identifier: "A177D0F5-DEB1-41CB-83F4-B129C0CFC52D", major: 0, minor: 0, location: "S02", detailLocation: "A06-A07")
    ]
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self){
                print("monitoring is available")
                if CLLocationManager.isRangingAvailable(){
                    print("ranging is available")
                    startScanning()
                } else {
                    print("ranging is not available")
                }
            } else {
                print("monitoring is not available")
            }
        }
    }
    
    func startScanning() {
        print("start scanning")
        
        // Define multiple beacon regions with their UUIDs and identifiers
        var beaconRegions:[CLBeaconRegion] = []
                
        // Define multiple constraints
        var beaconConstraints:[CLBeaconIdentityConstraint] = []
        
        for beaconLocation in beaconLocations {
            if let uuid = UUID(uuidString: beaconLocation.identifier) {
                let constraint = CLBeaconIdentityConstraint(
                    uuid: uuid,
                    major: CLBeaconMajorValue(beaconLocation.major),
                    minor: CLBeaconMinorValue(beaconLocation.minor)
                )
                
                beaconConstraints.append(constraint)
                        
                let beaconRange = CLBeaconRegion(beaconIdentityConstraint: constraint, identifier: beaconLocation.identifier)
                
                beaconRegions.append(beaconRange)
                
                locationManager?.startMonitoring(for: beaconRange)
                locationManager?.startRangingBeacons(satisfying: constraint)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstrain: CLBeaconIdentityConstraint) {
        
        if let foundBeacon = beacons.first {
            
            if foundBeacon.rssi < 0 {
                if var location = beaconLocations.first(
                    where: {
                        $0.identifier == foundBeacon.uuid.uuidString &&
                        $0.major == foundBeacon.major.intValue &&
                        $0.minor == foundBeacon.minor.intValue
                    }) {
                    location.rssi = foundBeacon.rssi
                    print(location.identifier + " - " + String(location.rssi))
                    print("---------------------------------------------------------")
                    if currentNearestLocation == nil {
                        currentNearestLocation = location
                    } else {
                        if currentNearestLocation?.rssi ?? 0 < location.rssi {
                            currentNearestLocation = location
                        }
                    }
                    print("CURRENT: " + (currentNearestLocation?.identifier ?? "unknown") + " - " + String(currentNearestLocation?.rssi ?? 1))
                }
            } else {
                currentNearestLocation = nil
            }
        }
    }
}
