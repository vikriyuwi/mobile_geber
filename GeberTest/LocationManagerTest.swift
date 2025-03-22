import XCTest
import CoreLocation
@testable import geber

class LocationManagerTest: XCTestCase {
    var locationManager: LocationManager!
    
    override func setUpWithError() throws {
        locationManager = LocationManager()
    }
    
    override func tearDownWithError() throws {
        locationManager = nil
    }
    
    func testStartScanning() {
        let expectation = self.expectation(description: "Start scanning for beacons")
        
        locationManager.observeMajorsToBeaconLocations {
            XCTAssertFalse(self.locationManager.beaconLocations.isEmpty, "Beacon locations should not be empty after observing majors")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
