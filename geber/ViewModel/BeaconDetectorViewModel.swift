//
//  BeaconDetectorViewModel.swift
//  geber
//
//  Created by Vikri Yuwi on 25/9/24.
//

import CoreBluetooth
import Foundation
import Combine

struct BeaconPeripheral {
    let peripheral: CBPeripheral
    let rssi: NSNumber
}

class BeaconDetectorViewModel: NSObject, ObservableObject, CBCentralManagerDelegate {
    var centralManager: CBCentralManager!
    @Published var discoveredBeacons: [CBPeripheral] = []
    
    //B1CB1571-3779-B0E6-0995-DE519D9FDB4E = laptop
    //6CD0DB38-E82E-F348-ED58-541E8B5A9761 = ipad
    
    
    var beaconLocations: [BeaconModel] = [
        BeaconModel(identifier: "B1CB1571-3779-B0E6-0995-DE519D9FDB4E", major: 0, minor: 0, location: "S01", detailLocation: "A01-A05"),
        BeaconModel(identifier: "6CD0DB38-E82E-F348-ED58-541E8B5A9761", major: 0, minor: 0, location: "S02", detailLocation: "A06-A07")
    ]
    
    @Published var nearestBeacon: BeaconModel?
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            startScanning()
        } else {
            stopScanning()
        }
    }
    
    func startScanning() {
        guard let centralManager = centralManager else {
            return
        }
        if centralManager.state == .poweredOn {
            var UUID: [CBUUID] = []
            
            let options: [String: Any] = [CBCentralManagerScanOptionAllowDuplicatesKey: true]
            centralManager.scanForPeripherals(withServices: UUID, options: options)
        }
    }
    
    func stopScanning() {
        centralManager.stopScan()
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        if !discoveredBeacons.contains(peripheral) {
            discoveredBeacons.append(peripheral)
            print(peripheral)
        }
        
        discoveredBeacons.sort(by: { $0.rssi?.intValue ?? -1000 > $1.rssi?.intValue ?? -1000 })
        
        setNearestPeripheral()
    }
    
    func setNearestPeripheral() {
        if let beacon = beaconLocations.first(
        where: {
            $0.identifier == discoveredBeacons.first?.identifier.uuidString
        }) {
            nearestBeacon = beacon
        }
    }
}
