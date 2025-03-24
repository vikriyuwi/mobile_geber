import XCTest
@testable import geber

@MainActor
class VehicleInformationViewModelTests: XCTestCase {
    
    var viewModel: VehicleInformationViewModel!
    var mockUserDefaults: MockUserDefaultService!
    var swiftDataService: SwiftDataService = SwiftDataService.shared
    
    var v1 = VehicleModel(model: "Test vehicle", plateNumber: "A 1111 XC", color: "Red")
    var v2 = VehicleModel(model: "Test vehicle2", plateNumber: "A 1111 XC", color: "Red")
    
    override func setUp() {
        super.setUp()
        mockUserDefaults = MockUserDefaultService()
        viewModel = VehicleInformationViewModel(userDefaultService: mockUserDefaults)
    }
    
    override func tearDown() {
        viewModel = nil
        mockUserDefaults = nil
        swiftDataService.remove(v1)
        swiftDataService.remove(v2)
        super.tearDown()
    }
    
    func testInitialValues() {
        XCTAssertEqual(viewModel.username, "Set up")
        XCTAssertTrue(viewModel.vehicles.isEmpty)
    }
    
    func testSaveUsername() {
        viewModel.saveUsername("John Doe")
        XCTAssertEqual(mockUserDefaults.savedData["usernameKey"] as? String, "John Doe")
    }
    
    func testRemoveUsername() {
        viewModel.removeUsername()
        XCTAssertEqual(viewModel.username, "Set up")
    }
    
    func testSaveVehicleActive() {
        let vehicle = VehicleModel(model: "Tesla", plateNumber: "1234", color: "Red")
        viewModel.saveVehicleActive(vehicle)
        
        XCTAssertEqual(mockUserDefaults.savedData["vehicleModelActive"] as? String, "Tesla")
        XCTAssertEqual(mockUserDefaults.savedData["vehiclePlateNumberActive"] as? String, "1234")
        XCTAssertEqual(mockUserDefaults.savedData["vehicleColorActive"] as? String, "Red")
    }
    
    func testRemoveVehicleActive() {
        viewModel.removeVehicleActive()
        XCTAssertNil(mockUserDefaults.savedData["vehicleModelActive"])
        XCTAssertNil(mockUserDefaults.savedData["vehiclePlateNumberActive"])
        XCTAssertNil(mockUserDefaults.savedData["vehicleColorActive"])
    }
    
    func testLoadVehicles() {
        swiftDataService.add(v1)
        swiftDataService.add(v2)
        viewModel.loadVehicles()
        XCTAssertEqual(viewModel.vehicles.count, 2)
    }
        
    func testSaveVehicle() {
        viewModel.saveVehicle("Test vehicle", "A 1111 XC", "Red")
        XCTAssertEqual(viewModel.vehicles.count, 1)
        XCTAssertEqual(viewModel.vehicles.first?.model, "Test vehicle")
    }
        
    func testRemoveVehicle() {
        let firstCount = viewModel.vehicles.count
        swiftDataService.add(v1)
        viewModel.removeVehicle(v1)
        XCTAssertEqual(firstCount, viewModel.vehicles.count)
    }
}
