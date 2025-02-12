//
//  HelpViewModelTest.swift
//  HelpViewModelTest
//
//  Created by Vikri Yuwi on 05/01/25.
//

//
//  HelpViewModelTests.swift
//  geberTests
//
//  Created by win win on 20/9/24.
//

import XCTest
import CoreLocation
@testable import geber

class HelpViewModelTests: XCTestCase {
    var viewModel: HelpViewModel!
    var mockUserDefaultService: MockUserDefaultService!
    
    override func setUp() {
        super.setUp()
        mockUserDefaultService = MockUserDefaultService()
        viewModel = HelpViewModel(userDefaultService: mockUserDefaultService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockUserDefaultService = nil
        super.tearDown()
    }
    
    func testInitialUsernameSetup() {
        // Check the initial value of the username
        XCTAssertEqual(viewModel.username, "Set up")
        
        // Update username in mock user defaults
        mockUserDefaultService.save(key: "usernameKey", value: "TestUser")
        
        // Trigger UserDefaults change
        NotificationCenter.default.post(name: .userDefaultsDidChange, object: "usernameKey")
        
        // Check if viewModel updated the username
        XCTAssertEqual(viewModel.username, "TestUser")
    }
    
    func testVehicleActiveSetup() {
        // Check the initial values of vehicleActive
        XCTAssertEqual(viewModel.vehicleActive.model, "")
        XCTAssertEqual(viewModel.vehicleActive.plateNumber, "")
        XCTAssertEqual(viewModel.vehicleActive.color, "")
        
        // Update vehicle data in mock user defaults
        mockUserDefaultService.save(key: "vehicleModelActive", value: "CarModel")
        mockUserDefaultService.save(key: "vehiclePlateNumberActive", value: "1234ABC")
        mockUserDefaultService.save(key: "vehicleColorActive", value: "Blue")
        
        // Trigger UserDefaults changes
        NotificationCenter.default.post(name: .userDefaultsDidChange, object: "vehicleModelActive")
        NotificationCenter.default.post(name: .userDefaultsDidChange, object: "vehiclePlateNumberActive")
        NotificationCenter.default.post(name: .userDefaultsDidChange, object: "vehicleColorActive")
        
        // Check if viewModel updated vehicleActive
        XCTAssertEqual(viewModel.vehicleActive.model, "CarModel")
        XCTAssertEqual(viewModel.vehicleActive.plateNumber, "1234ABC")
        XCTAssertEqual(viewModel.vehicleActive.color, "Blue")
    }
    
    func testTimerStartsOnHelpRequest() {
        let expectation = XCTestExpectation(description: "Help request should trigger timer")
        
        viewModel.timeRemainingDefault = 5 // Shorten the timer for testing
        
        // Mock or disable PPT communication during this test if needed
        // For example, use a mock object for viewModel.sendHelpRequest() if it involves PPT interaction.
        
        // Call sendHelpRequest
        viewModel.sendHelpRequest()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(self.viewModel.timeRemaining > 0, "Timer should have started")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
    }

}
