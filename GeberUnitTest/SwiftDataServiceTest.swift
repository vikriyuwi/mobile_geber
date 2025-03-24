import XCTest
@testable import geber

@MainActor
final class SwiftDataServiceTests: XCTestCase {
    var service: SwiftDataService!
    
    override func setUp() {
        super.setUp()
        service = SwiftDataService.shared
    }
    
    override func tearDown() {
        service.removeAll(ofType: TestModel.self) // Clean up after each test
        super.tearDown()
    }
    
    func testAddAndFetchObject() {
        let testObject = TestModel(name: "Test")
        service.add(testObject)
        
        let fetchedObjects = service.fetch() as [TestModel]
        XCTAssertEqual(fetchedObjects.count, 1)
        XCTAssertEqual(fetchedObjects.first?.name, "Test")
    }
    
    func testRemoveObject() {
        let testObject = TestModel(name: "To be removed")
        service.add(testObject)
        
        service.remove(testObject)
        let fetchedObjects = service.fetch() as [TestModel]
        XCTAssertTrue(fetchedObjects.isEmpty)
    }
    
    func testRemoveAllObjects() {
        let testObject1 = TestModel(name: "First")
        let testObject2 = TestModel(name: "Second")
        service.add(testObject1)
        service.add(testObject2)
        
        service.removeAll(ofType: TestModel.self)
        let fetchedObjects = service.fetch() as [TestModel]
        XCTAssertTrue(fetchedObjects.isEmpty)
    }
}
