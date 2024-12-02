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
    // firebase database
    private let ref = Database.database().reference()
    // uuid beacon
    private let beaconUUID = "EF63C140-2AF4-4E1E-AAB3-340055B3BB4B"
    
    // location manager
    @Published public var locationManager: CLLocationManager?
    @Published public var currentNearestLocation: BeaconModel? = nil
    @Published public var majors: [MajorModel] = []
//    @Published public var currentLocation: String = "Unknwon"
//    @Published public var currentDetailLocation: String = "Unknown456ghvc "
//    @Published public var currentRssi: Int = 0
    
    // for request time
    @Published public var timer: Timer?
    @Published public var timeRemaining: TimeInterval = 0
    private var timeRemainingDefault: TimeInterval = 60
    
    // userdefault keys
    private let lastRequestTimeKey: String = "lastRequestTime"
    private let usernameKey: String = "usernameKey"
    private let vehicleModelActiveKey: String = "vehicleModelActive"
    private let vehiclePlateNumberActiveKey: String = "vehiclePlateNumberActive"
    private let vehicleColorActiveKey: String = "vehicleColorActive"
    // default value for UserDefaults
    public let usernameDefault: String = "Set up"
    public let vehicleAttributeActiveDefault:String = ""
    
    // location list
    private var beaconLocations: [BeaconModel] = []
    
    // notificagtion subscribe
    private var cancellables:Set<AnyCancellable> = Set<AnyCancellable>()
    
    init(userDefaultService: UserDefaultServiceProtocol = UserDefaultService()) {
        
        
        // read userdefault data
        self.userDefaultService = userDefaultService
        
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
        
        observeMajorsObject()
    }
    
    func observeMajorsObject() {
        ref.child("majors").observe(.value) { snapshot in
            guard snapshot.exists(), let children = snapshot.children.allObjects as? [DataSnapshot] else {
                print("No children found or snapshot does not exist.")
                return
            }
            
            self.majors = children.compactMap { childSnapshot in
                guard let dictionary = childSnapshot.value as? [String: Any] else { return nil }
                do {
                    let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
                    return try JSONDecoder().decode(MajorModel.self, from: data)
                } catch {
//                    print("Error decoding MajorModel: \(error)")
                    return nil
                }
            }
            
            for major in self.majors {
                for minor in major.minors {
                    let beaconModel = BeaconModel(
                        identifier: self.beaconUUID, // Example identifier
                        major: major.id,
                        minor: minor.id,
                        location: major.location,
                        detailLocation: minor.detailLocation
                    )
                    self.beaconLocations.append(beaconModel)
                }
            }
            
            // location manager
            self.locationManager = CLLocationManager()
            self.locationManager?.delegate = self
            self.locationManager?.requestWhenInUseAuthorization()
        }
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
    
    private func runTimer() {
        withAnimation(.spring()) {
            DispatchQueue.main.async {
                self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    if self.timeRemaining > 0 {
                        self.timeRemaining -= 1
                    } else {
                        self.stopTimer()
                    }
                }
            }
        }
    }
    
    private func stopTimer() {
        withAnimation(.spring()){
            self.timer?.invalidate()
            self.timeRemaining = 0
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
                    uuid: uuid
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
    
    public func sendHelpRequest() {
        authenticateUser { isAuthenticate in
            if isAuthenticate {
                let helpRequest = HelpRequestModel(timestamps: Date(), name: self.username, location: self.currentNearestLocation?.location ?? "Unknown", detailLocation: self.currentNearestLocation?.detailLocation ?? "Unknown", vehicle: self.vehicleActive)
                self.ref.child("helpRequests").childByAutoId().setValue(helpRequest.helpRequestToDictionary) { error, _ in
                    if let error = error {
                        print("Error writing data: \(error.localizedDescription)")
                    } else {
                        
                        self.userDefaultService.save(key: self.lastRequestTimeKey, value: Calendar.current.date(byAdding: .second, value: 60, to: Date()))
                        self.timeRemaining = self.timeRemainingDefault
                        self.runTimer()
                    }
                }
            } else {
                print("Authentication failed")
            }
        }
    }
}
