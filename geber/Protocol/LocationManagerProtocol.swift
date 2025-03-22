//
//  LocationManagerProtocol.swift
//  geber
//
//  Created by Vikri Yuwi on 22/03/25.
//
import SwiftUI
import CoreLocation

protocol LocationManagerProtocol {
    var beaconLocations: [BeaconModel] { get set }
    var currentNearestLocation: BeaconModel? { get set }
    
    func startScanning()
    func stopScanning()
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying constraint: CLBeaconIdentityConstraint)
}
