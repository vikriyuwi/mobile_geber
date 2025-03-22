//
//  HelpViewModel.swift
//  geber
//
//  Created by win win on 20/9/24.
//

import SwiftUI
import Combine
import CoreLocation
import FirebaseDatabase

@MainActor
class HelpViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {

    @Published public var username: String = "Set up"
    @Published public var vehicleActive: VehicleModel = VehicleModel(model: "", plateNumber: "", color:"")
    
    public let userDefaultService = UserDefaultService.shared
    public let swiftDataService = SwiftDataService.shared
    public let realtimeDatabaseService = RealtimeDatabaseService.shared
    public let biometricAuthService = BiometricAuthService.shared

    @Published public var locationManager = LocationManager()
    @Published public var currentNearestLocation: BeaconModel? = nil
    @Published public var majors: [MajorModel] = []
    
    // for request time
    @Published public var timer: Timer?
    @Published public var timeRemaining: TimeInterval = 0
    public var timeRemainingDefault: TimeInterval = 60
    

    public let lastRequestTimeKey: String = "lastRequestTime"
    public let usernameKey: String = "usernameKey"
    public let vehicleModelActiveKey: String = "vehicleModelActive"
    public let vehiclePlateNumberActiveKey: String = "vehiclePlateNumberActive"
    public let vehicleColorActiveKey: String = "vehicleColorActive"

    public let usernameDefault: String = "Set up"
    public let vehicleAttributeActiveDefault:String = ""
    
    // location list
    public var beaconLocations: [BeaconModel] = []
    
    // notificagtion subscribe
    public var cancellables:Set<AnyCancellable> = Set<AnyCancellable>()
    
    override init() {
        
        super.init()
        
        getLastRequestTime()
        
        self.username = userDefaultService.load(key: usernameKey, defaultValue: "Set up")
        self.vehicleActive.model = userDefaultService.load(key: vehicleModelActiveKey, defaultValue: "")
        self.vehicleActive.plateNumber = userDefaultService.load(key: vehiclePlateNumberActiveKey, defaultValue: "")
        self.vehicleActive.color = userDefaultService.load(key: vehicleColorActiveKey, defaultValue: "")
        
        // observe user default
        NotificationCenter.default.publisher(for: .userDefaultsDidChange)
            .sink { [weak self] notification in
                guard let key = notification.object as? String else { return }
                self?.handleUserDefaultsChange(for: key)
            }
            .store(in: &cancellables)
        
        observeNearestBeacon()
        locationManager.startScanning()
    }
    
    private func observeNearestBeacon() {
        locationManager.$currentNearestLocation
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newLocation in
                self?.currentNearestLocation = newLocation
            }
            .store(in: &cancellables)
    }
    
    func getLastRequestTime() {
        let rightnow = Date()
        if userDefaultService.load(key: lastRequestTimeKey, defaultValue: rightnow) > Date() {
            self.timeRemaining = userDefaultService.load(key: lastRequestTimeKey, defaultValue: Date()).timeIntervalSinceNow
            self.runTimer()
        } else {
            self.timeRemaining = 0
        }
    }
    
    public func handleUserDefaultsChange(for key: String) {
        switch key {
        case usernameKey:
            self.username = userDefaultService.load(key: usernameKey, defaultValue: usernameDefault)
        case vehicleModelActiveKey:
            self.vehicleActive.model = userDefaultService.load(key: vehicleModelActiveKey, defaultValue: vehicleAttributeActiveDefault)
        case vehiclePlateNumberActiveKey:
            self.vehicleActive.plateNumber = userDefaultService.load(key: vehiclePlateNumberActiveKey, defaultValue: vehicleAttributeActiveDefault)
        case vehicleColorActiveKey:
            self.vehicleActive.color = userDefaultService.load(key: vehicleColorActiveKey, defaultValue: vehicleAttributeActiveDefault)
        default:
            break
        }
    }
    
    public func runTimer() {
        withAnimation(.spring()) {
            DispatchQueue.main.async {
                self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    DispatchQueue.main.async {
                        if self.timeRemaining > 0 {
                            self.timeRemaining -= 1
                        } else {
                            self.stopTimer()
                        }
                    }
                }
            }
        }
    }
    
    public func stopTimer() {
        withAnimation(.spring()){
            self.timer?.invalidate()
            self.timeRemaining = 0
        }
    }
    
    public func startScanning() {
        locationManager.startScanning()
    }
    
    public func stopScanning() {
        locationManager.stopScanning()
    }
    
    public func sendHelpRequest() {
        biometricAuthService.authenticateUser { isAuthenticate in
            if isAuthenticate {
                let helpRequest = HelpRequestModel(timestamps: Date(), name: self.username, location: self.currentNearestLocation?.location ?? "Unknown", detailLocation: self.currentNearestLocation?.detailLocation ?? "Unknown", vehicle: self.vehicleActive)
                self.realtimeDatabaseService.writeDataAutoId(path: "helpRequests", data: helpRequest) { error in
                    DispatchQueue.main.async {
                        if let error = error {
                            print("Error writing data: \(error.localizedDescription)")
                        } else {
                            self.userDefaultService.save(key: self.lastRequestTimeKey, value: Calendar.current.date(byAdding: .second, value: 60, to: Date()))
                            self.timeRemaining = self.timeRemainingDefault
                            self.runTimer()
                        }
                    }
                }
            } else {
                print("Authentication failed")
            }
        }
    }
}
