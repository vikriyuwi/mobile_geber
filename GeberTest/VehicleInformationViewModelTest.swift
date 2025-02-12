//
//  VehicleInformationTest.swift
//  geber
//
//  Created by Vikri Yuwi on 06/01/25.
//

import XCTest
import Combine
@testable import geber

final class VehicleInformationViewModelTest: XCTestCase {
    
    var viewModel: VehicleInformationViewModel!
    var mockUserDefaultServiceVehicle: MockUserDefaultServiceVehicle!
    var swiftDataService: SwiftDataService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockUserDefaultServiceVehicle = MockUserDefaultServiceVehicle()
        swiftDataService = SwiftDataService.shared
        viewModel = VehicleInformationViewModel(userDefaultService: mockUserDefaultServiceVehicle)
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        mockUserDefaultServiceVehicle = nil
        swiftDataService = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testInitialLoadFromUserDefaults() {
        mockUserDefaultServiceVehicle.savedValues = [
            "usernameKey": "TestUser",
            "vehicleModelActive": "TestModel",
            "vehiclePlateNumberActive": "123ABC",
            "vehicleColorActive": "Red"
        ]
        
        viewModel = VehicleInformationViewModel(userDefaultService: mockUserDefaultServiceVehicle)
        
        XCTAssertEqual(viewModel.username, "TestUser")
        XCTAssertEqual(viewModel.vehicleActive.model, "TestModel")
        XCTAssertEqual(viewModel.vehicleActive.plateNumber, "123ABC")
        XCTAssertEqual(viewModel.vehicleActive.color, "Red")
    }
    
    func testSaveUsername() {
        viewModel.saveUsername("NewUser")
        XCTAssertEqual(mockUserDefaultServiceVehicle.savedValues["usernameKey"] as? String, "NewUser")
    }
    
    func testRemoveUsername() {
        viewModel.removeUsername()
        XCTAssertEqual(mockUserDefaultServiceVehicle.removedKeys, ["usernameKey"])
        XCTAssertEqual(viewModel.username, viewModel.usernameDefault)
    }
    
    func testSaveVehicleActive() {
        let vehicle = VehicleModel(model: "NewModel", plateNumber: "456DEF", color: "Blue")
        viewModel.saveVehicleActive(vehicle)
        
        XCTAssertEqual(mockUserDefaultServiceVehicle.savedValues["vehicleModelActive"] as? String, "NewModel")
        XCTAssertEqual(mockUserDefaultServiceVehicle.savedValues["vehiclePlateNumberActive"] as? String, "456DEF")
        XCTAssertEqual(mockUserDefaultServiceVehicle.savedValues["vehicleColorActive"] as? String, "Blue")
    }
    
    func testRemoveVehicleActive() {
        viewModel.removeVehicleActive()
        XCTAssertEqual(mockUserDefaultServiceVehicle.removedKeys, [
            "vehicleModelActive",
            "vehiclePlateNumberActive",
            "vehicleColorActive"
        ])
        XCTAssertEqual(viewModel.vehicleActive.model, viewModel.vehicleAttributeActiveDefault)
        XCTAssertEqual(viewModel.vehicleActive.plateNumber, viewModel.vehicleAttributeActiveDefault)
        XCTAssertEqual(viewModel.vehicleActive.color, viewModel.vehicleAttributeActiveDefault)
    }
    
    func testAddVehicle() {
        let initCount = swiftDataService.vehicles.count
        let testVehicle = VehicleModel(model: "Car", plateNumber: "123XYZ", color: "Blue")
            
        swiftDataService.addVehicle(testVehicle)
            
        XCTAssertEqual(swiftDataService.vehicles.count, initCount+1)
        XCTAssertEqual(swiftDataService.vehicles.last?.model, "Car")
        XCTAssertEqual(swiftDataService.vehicles.last?.plateNumber, "123XYZ")
        XCTAssertEqual(swiftDataService.vehicles.last?.color, "Blue")
    }
    
    func testRemoveVehicle() {
        let initCount = swiftDataService.vehicles.count
        let testVehicle = VehicleModel(model: "TestModel", plateNumber: "123ABC", color: "Red")
            
        swiftDataService.addVehicle(testVehicle)
            
            // Remove the vehicle
        viewModel.removeVehicle(testVehicle)
            
        XCTAssertEqual(swiftDataService.vehicles.count, initCount)
    }
}
