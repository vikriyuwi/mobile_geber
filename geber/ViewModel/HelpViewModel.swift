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
import FirebaseDatabase

class HelpViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    // app data
    @Published public var username: String = "Set up"
    @Published public var vehicleActive: VehicleModel = VehicleModel(model: "", plateNumber: "", color:"")
    
    // use userdefault service
    private let userDefaultService: UserDefaultServiceProtocol
    // use swiftdata service
    private let dataSource = SwiftDataService.shared
    
    @Published public var helpRequests: [HelpRequestModel] = []
    
    // location manager
    @Published public var locationManager: CLLocationManager?
    @Published public var currentNearestLocation: BeaconModel? = nil
    
    @Published public var isSent: Bool = false
    @Published public var timer: Timer?
    @Published public var timeRemaining: TimeInterval = 180
    private var timeRemainingDefault: TimeInterval = 180
    
    // userdefault keys
    private let usernameKey: String = "usernameKey"
    private let vehicleModelActiveKey: String = "vehicleModelActive"
    private let vehiclePlateNumberActiveKey: String = "vehiclePlateNumberActive"
    private let vehicleColorActiveKey: String = "vehicleColorActive"
    // default value for UserDefaults
    public let usernameDefault: String = "Set up"
    public let vehicleAttributeActiveDefault:String = ""
    // location list
    private var beaconLocations: [BeaconModel] = [
        BeaconModel(identifier: "EF63C140-2AF4-4E1E-AAB3-340055B3BB4B", major: 0, minor: 0, location: "S01", detailLocation: "A01-A05"),
        BeaconModel(identifier: "A177D0F5-DEB1-41CB-83F4-B129C0CFC52D", major: 0, minor: 0, location: "S02", detailLocation: "A06-A07")
    ]
    
    // firebase database
    private let ref = Database.database().reference()
    
    // notificagtion subscribe
    private var cancellables:Set<AnyCancellable> = Set<AnyCancellable>()
    
    init(userDefaultService: UserDefaultServiceProtocol = UserDefaultService()) {
        
        
        // read userdefault data
        self.userDefaultService = userDefaultService
        
        super.init()
        
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
        
        // location manager
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        
        // read help request data
        dataSource.$helpRequests
            .assign(to: &$helpRequests)
        
        // check existing help request data
        if self.helpRequests.count > 0 {
            let timeInterval = Date().timeIntervalSince(self.helpRequests[self.helpRequests.count-1].timestamps)
            if timeInterval > timeRemainingDefault {
                self.removeHelpRequest()
            } else {
                timeRemaining = timeRemainingDefault - timeInterval
                setTimer()
            }
        }
    }
    
    private func handleUserDefaultsChange(for key: String) {
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
    
    private func setTimer() {
        withAnimation(.spring()) {
            DispatchQueue.main.async {
                self.isSent = true
                self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    if self.timeRemaining > 0 {
                        self.timeRemaining -= 1
                    } else {
                        self.stopTimer()
                    }
                }
            }
        }
//        withAnimation(.spring().delay(0.5)) {
//            DispatchQueue.main.async {
//                self.isSent = true
//                self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
//                    DispatchQueue.main.async {
//                        if self.timeRemaining > 0 {
//                            self.timeRemaining -= 1
//                        } else {
//                            self.stopTimer()
//                        }
//                    }
//                }
//            }
//        }
    }
    
    private func stopTimer() {
        self.removeHelpRequest()
        withAnimation(.spring()){
            self.isSent = false
            self.timer?.invalidate()
            self.timeRemaining = 180
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self){
                if CLLocationManager.isRangingAvailable(){
                    startScanning()
                } else {
                }
            }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstrain: CLBeaconIdentityConstraint) {
        
        if let foundBeacon = beacons.first {
            
            if foundBeacon.rssi < 0 {
                if let location = beaconLocations.first(
                    where: {
                        $0.identifier == foundBeacon.uuid.uuidString &&
                        $0.major == foundBeacon.major.intValue &&
                        $0.minor == foundBeacon.minor.intValue
                    }) {
                    location.rssi = foundBeacon.rssi
                    if currentNearestLocation == nil {
                        currentNearestLocation = location
                    } else {
                        if currentNearestLocation?.rssi ?? 0 < location.rssi {
                            currentNearestLocation = location
                        }
                    }
                }
            } else {
                currentNearestLocation = nil
            }
        }
    }
    
    public func startScanning() {
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
    
    func authenticateUser(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?

        // Check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // It's possible, so go ahead and use it
            let reason = "Face ID or Touch ID is required to send a help request"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                // Authentication has now completed
                if success {
                    // Pass the result back through the completion handler
                    completion(true)
                } else {
                    completion(false)
                }
            }
        } else {
            // Biometrics not available or not set up, so return failure
            completion(false)
        }
    }

    public func saveHelpRequest(_ helpRequest: HelpRequestModel) {
        dataSource.addHelpRequest(helpRequest)
    }
    
    public func removeHelpRequest() {
        dataSource.removeAllHelpRequest()
    }
    
    public func sendHelpRequest() {
        authenticateUser { isAuthenticate in
            if isAuthenticate {
                let helpRequest = HelpRequestModel(timestamps: Date(), name: self.username, location: self.currentNearestLocation?.location ?? "unknown", detailLocation: self.currentNearestLocation?.detailLocation ?? "unknown")
                self.saveHelpRequest(helpRequest)
                print("\(self.helpRequests[self.helpRequests.count-1].timestamps) - \(self.helpRequests[self.helpRequests.count-1].name)")
                self.setTimer()
            } else {
                print("Authentication failed")
            }
        }
    }
}
