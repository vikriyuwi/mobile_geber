//
//  HelpViewModel.swift
//  geber
//
//  Created by win win on 20/9/24.
//

import SwiftUI
import Combine
import CoreLocation
import LocalAuthentication

class HelpViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var locationManager: CLLocationManager?
    @Published var currentNearestLocation: BeaconModel? = nil
    
    @Published var location:Int? = 2
    @Published var isSent:Bool = false
    
    @Published var timer:Timer?
    @Published var timeRemaining:TimeInterval = 10
    
    private func setTimer() {
        withAnimation(.spring().delay(0.5)){
            isSent = true
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.stopTimer()
                }
            }
        }
    }
    
    private func stopTimer() {
        withAnimation(.spring()){
            isSent = false
            timer?.invalidate()
            timeRemaining = 10
        }
    }
    
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
                if let location = beaconLocations.first(
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
    
    func authenticate() -> Bool {
        let context = LAContext()
        var error: NSError?
        var result = false

        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // it's possible, so go ahead and use it
            let reason = "Face ID or Touch ID is required to send a help request"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                // authentication has now completed
                if success {
                    result = true
                } else {
                    result = false
                }
            }
            
            return result
        } else {
            return true
        }
    }
    
    func sendHelpRequest() {
        if authenticate() {
            setTimer()
        }
    }
}
