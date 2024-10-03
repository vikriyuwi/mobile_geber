//
//  VehicleInformationViewModel.swift
//  geber
//
//  Created by Vikri Yuwi on 2/10/24.
//
import SwiftUI
import Combine

class VehicleInformationViewModel: ObservableObject {
    @Published var username: String = "Set up"
    @Published var vehicleActive: VehicleModel = VehicleModel(Model: "", PlateNumber: "", Color:"")
    @Published var vehicles: [VehicleModel] = []
    
    // use userdefault service
    private let userDefaultService: UserDefaultServiceProtocol
    // userdefault keys
    private let usernameKey = "usernameKey"
    private let vehicleModelActiveKey = "vehicleModelActive"
    private let vehiclePlateNumberActiveKey = "vehiclePlateNumberActive"
    private let vehicleColorActiveKey = "vehicleColorActive"
    
    let usernameDefault = "Set up"
    let vehicleAttributeActiveDefault = ""
    
    // use swiftdata service
    private let dataSource = SwiftDataService.shared
    
    private var cancellables = Set<AnyCancellable>()
    
    
    init(userDefaultService: UserDefaultServiceProtocol = UserDefaultService()) {
        
        // read userdefault data
        self.userDefaultService = userDefaultService
        self.username = userDefaultService.load(key: usernameKey, defaultValue: "Set up")
        self.vehicleActive.Model = userDefaultService.load(key: vehicleModelActiveKey, defaultValue: "")
        self.vehicleActive.PlateNumber = userDefaultService.load(key: vehiclePlateNumberActiveKey, defaultValue: "")
        self.vehicleActive.Color = userDefaultService.load(key: vehicleColorActiveKey, defaultValue: "")
        
        // observe user default
        NotificationCenter.default.publisher(for: .userDefaultsDidChange)
            .sink { [weak self] notification in
                guard let key = notification.object as? String else { return }
                self?.handleUserDefaultsChange(for: key)
            }
            .store(in: &cancellables)
        
        // read vehicles data
        dataSource.$vehicles
            .assign(to: &$vehicles)
    }
    
    private func handleUserDefaultsChange(for key: String) {
        switch key {
        case usernameKey:
            self.username = userDefaultService.load(key: usernameKey, defaultValue: usernameDefault)
        case vehicleModelActiveKey:
            self.vehicleActive.Model = userDefaultService.load(key: vehicleModelActiveKey, defaultValue: vehicleAttributeActiveDefault)
        case vehiclePlateNumberActiveKey:
            self.vehicleActive.PlateNumber = userDefaultService.load(key: vehiclePlateNumberActiveKey, defaultValue: vehicleAttributeActiveDefault)
        case vehicleColorActiveKey:
            self.vehicleActive.Color = userDefaultService.load(key: vehicleColorActiveKey, defaultValue: vehicleAttributeActiveDefault)
        default:
            break
        }
    }
    
    func saveUsername(_ username: String) {
        userDefaultService.remove(key: usernameKey)
        userDefaultService.save(key: usernameKey, value: username)
    }
    
    func saveVehicleActive(_ vehicle: VehicleModel) {
        userDefaultService.remove(key: vehicleModelActiveKey)
        userDefaultService.remove(key: vehiclePlateNumberActiveKey)
        userDefaultService.remove(key: vehicleColorActiveKey)
        userDefaultService.save(key: vehicleModelActiveKey, value: vehicle.Model)
        userDefaultService.save(key: vehiclePlateNumberActiveKey, value: vehicle.PlateNumber)
        userDefaultService.save(key: vehicleColorActiveKey, value: vehicle.Color)
    }
    
    func deteleUsername() {
        userDefaultService.remove(key: usernameKey)
        username = usernameDefault
    }
    
    func deleteVehicleActive() {
        userDefaultService.remove(key: vehicleModelActiveKey)
        userDefaultService.remove(key: vehiclePlateNumberActiveKey)
        userDefaultService.remove(key: vehicleColorActiveKey)
        vehicleActive = VehicleModel(Model: vehicleAttributeActiveDefault, PlateNumber: vehicleAttributeActiveDefault, Color:vehicleAttributeActiveDefault)
    }
    
    func loadVehicle() {
        dataSource.fetchVehicle()
    }
    
    func saveVehicle(_ model: String, _ plateNumber: String, _ color: String) {
        let vehicle = VehicleModel(Model: model, PlateNumber: plateNumber, Color: color)
        dataSource.addVehicle(vehicle)
    }
    
    func deleteVehicle(_ vehicle: VehicleModel) {
        dataSource.removeVehicle(vehicle)
    }
}
