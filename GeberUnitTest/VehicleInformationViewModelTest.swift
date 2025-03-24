import XCTest
@testable import geber

@MainActor
class VehicleInformationViewModelTests: XCTestCase {
    
    var viewModel: VehicleInformationViewModel!
    var mockUserDefaults: MockUserDefaultService!
    
    override func setUp() {
        super.setUp()
        mockUserDefaults = MockUserDefaultService()
        viewModel = VehicleInformationViewModel(userDefaultService: mockUserDefaults)
    }
    
    override func tearDown() {
        viewModel = nil
        mockUserDefaults = nil
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
}
