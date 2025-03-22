import XCTest
@testable import geber

@MainActor
final class SwiftDataServiceTests: XCTestCase {
    var service: SwiftDataService!

    override func setUpWithError() throws {
        service = SwiftDataService.shared
    }

    override func tearDownWithError() throws {
        service = nil
    }
    
    func testAddAndFetchVehicle() {
        let vehicle = VehicleModel(model: "Toyota Camry", plateNumber: "ABC123", color: "Blue")
        service.addVehicle(vehicle)
        
        let vehicles = service.fetchVehicle()
        XCTAssertTrue(vehicles.contains { $0.plateNumber == "ABC123" })
    }
    
    func testRemoveVehicle() {
        let vehicle = VehicleModel(model: "Honda Civic", plateNumber: "XYZ789", color: "Red")
        service.addVehicle(vehicle)
        service.removeVehicle(vehicle)
        
        let vehicles = service.fetchVehicle()
        XCTAssertFalse(vehicles.contains { $0.plateNumber == "XYZ789" })
    }
    
    func testAddAndFetchHelpRequest() {
        let helpRequest = HelpRequestModel(
            timestamps: Date(),
            name: "Vikri Yuwi",
            location: "East Area",
            detailLocation: "A01",
            vehicle: VehicleModel(model: "Mio", plateNumber: "N 1234 G", color: "Red"))
        service.addHelpRequest(helpRequest)
        
        let requests = service.fetchHelpRequests()
        XCTAssertFalse(requests.isEmpty)
    }
    
    func testRemoveAllHelpRequests() {
        service.addHelpRequest(
            HelpRequestModel(
                timestamps: Date(),
                name: "Vikri Yuwi",
                location: "East Area",
                detailLocation: "A01",
                vehicle: VehicleModel(model: "Mio", plateNumber: "N 1234 G", color: "Red"))
        )
        service.addHelpRequest(
            HelpRequestModel(
                timestamps: Date(),
                name: "Vikri Yuwi",
                location: "West Area",
                detailLocation: "B05",
                vehicle: VehicleModel(model: "Beat", plateNumber: "N 1111 G", color: "Black"))
        )
        service.removeAllHelpRequest()
        
        let requests = service.fetchHelpRequests()
        XCTAssertTrue(requests.isEmpty)
    }
}
