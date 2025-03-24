import XCTest
@testable import geber

class RealtimeDatabaseServiceTests: XCTestCase {
    var realtimeDatabaseService: RealtimeDatabaseService!
    
    override func setUpWithError() throws {
        realtimeDatabaseService = RealtimeDatabaseService.shared
    }
    
    override func tearDownWithError() throws {
        realtimeDatabaseService = nil
    }
    
    func testWriteDataAutoId() {
        let expectation = self.expectation(description: "Write data successfully")
        let minor = MinorModel(id: 1, detailLocation: "Room A")
        let major = MajorModel(id: 101, location: "Building 1", minor: [minor])
        
        realtimeDatabaseService.writeDataAutoId(path: "majors", data: major) { error in
            XCTAssertNil(error, "Failed to write data: \(String(describing: error))")
            
            // Verify that data was actually written
            self.realtimeDatabaseService.observeData(path: "majors") { (result: Result<[MajorModel], Error>) in
                switch result {
                case .success(let majors):
                    XCTAssertFalse(majors.isEmpty, "Data was not written to Firebase")
                    XCTAssertTrue(majors.contains { $0.id == 101 }, "Expected major ID not found in database")
                case .failure(let error):
                    XCTFail("Error fetching data after writing: \(error.localizedDescription)")
                }
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testObserveData() {
        let expectation = self.expectation(description: "Observe data successfully")
        
        realtimeDatabaseService.observeData(path: "majors") { (result: Result<[MajorModel], Error>) in
            switch result {
            case .success(let majors):
                XCTAssertNotNil(majors, "Fetched data is nil")
                XCTAssertGreaterThan(majors.count, 0, "Fetched majors should not be empty")
            case .failure(let error):
                XCTFail("Error observing data: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
