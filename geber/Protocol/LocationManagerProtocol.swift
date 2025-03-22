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
    var detectedBeacons: [BeaconModel] { get set }
    
    func startScanning(uuid: String)
    func stopScanning()
}
