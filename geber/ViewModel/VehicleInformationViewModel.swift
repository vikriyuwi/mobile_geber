//
//  VehicleInformationViewModel.swift
//  geber
//
//  Created by Vikri Yuwi on 2/10/24.
//
import SwiftUI
import Combine

@MainActor
class VehicleInformationViewModel: ObservableObject {
    @Published var username: String = "Set up"
    @Published var vehicleActive: VehicleModel = VehicleModel(model: "", plateNumber: "", color:"")
    @Published var vehicles: [VehicleModel] = []
    @Published var helpRequests: [HelpRequestModel] = []
    
    // use userdefault service
    private let userDefaultService: UserDefaultServiceProtocol
    // use swiftdata service
    private let dataSource = SwiftDataService.shared
    
    // userdefault keys
    private let usernameKey = "usernameKey"
    private let vehicleModelActiveKey = "vehicleModelActive"
    private let vehiclePlateNumberActiveKey = "vehiclePlateNumberActive"
    private let vehicleColorActiveKey = "vehicleColorActive"
    // default value for UserDefaults
    public let usernameDefault = "Set up"
    public let vehicleAttributeActiveDefault = ""
    // notificagtion subscribe
    private var cancellables = Set<AnyCancellable>()
    
    
    init(userDefaultService: UserDefaultServiceProtocol = UserDefaultService()) {
        
        // read userdefault data
        self.userDefaultService = userDefaultService
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
        
        // read vehicles data
//        dataSource.$vehicles
//            .assign(to: &$vehicles)
        loadVehicles()
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
    
    public func saveUsername(_ username: String) {
        userDefaultService.remove(key: usernameKey)
        userDefaultService.save(key: usernameKey, value: username)
    }
    
    public func removeUsername() {
        userDefaultService.remove(key: usernameKey)
        username = usernameDefault
    }
    
    public func saveVehicleActive(_ vehicle: VehicleModel) {
        userDefaultService.save(key: vehicleModelActiveKey, value: vehicle.model)
        userDefaultService.save(key: vehiclePlateNumberActiveKey, value: vehicle.plateNumber)
        userDefaultService.save(key: vehicleColorActiveKey, value: vehicle.color)
    }
    
    public func removeVehicleActive() {
        userDefaultService.remove(key: vehicleModelActiveKey)
        userDefaultService.remove(key: vehiclePlateNumberActiveKey)
        userDefaultService.remove(key: vehicleColorActiveKey)
    }
    
    public func loadVehicles() {
        vehicles = dataSource.fetchVehicle()
    }
    
    public func saveVehicle(_ model: String, _ plateNumber: String, _ color: String) {
        let vehicle = VehicleModel(model: model, plateNumber: plateNumber, color: color)
        dataSource.addVehicle(vehicle)
        loadVehicles()
    }
    
    public func removeVehicle(_ vehicle: VehicleModel) {
        dataSource.removeVehicle(vehicle)
        loadVehicles()
    }
}
