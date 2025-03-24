import XCTest
@testable import geber

class UserDefaultServiceTest: XCTestCase {
    let userDefaultService = UserDefaultService.shared
    let testKey = "testKey"
    
    override func setUpWithError() throws {
        // Pastikan tidak ada nilai sebelumnya sebelum setiap tes dijalankan
        userDefaultService.remove(key: testKey)
    }
    
    override func tearDownWithError() throws {
        // Hapus data setelah setiap tes
        userDefaultService.remove(key: testKey)
    }
    
    func testSaveAndLoadString() {
        let testValue = "Hello, World!"
        userDefaultService.save(key: testKey, value: testValue)
        
        let loadedValue: String = userDefaultService.load(key: testKey, defaultValue: "Default")
        XCTAssertEqual(loadedValue, testValue, "Loaded value should match saved value")
    }
    
    func testSaveAndLoadInt() {
        let testValue = 42
        userDefaultService.save(key: testKey, value: testValue)
        
        let loadedValue: Int = userDefaultService.load(key: testKey, defaultValue: 0)
        XCTAssertEqual(loadedValue, testValue, "Loaded value should match saved value")
    }
    
    func testSaveAndLoadStruct() {
        struct TestStruct: Codable, Equatable {
            let name: String
            let age: Int
        }
        
        let testValue = TestStruct(name: "John Doe", age: 25)
        userDefaultService.save(key: testKey, value: testValue)
        
        let loadedValue: TestStruct = userDefaultService.load(key: testKey, defaultValue: TestStruct(name: "Default", age: 0))
        XCTAssertEqual(loadedValue, testValue, "Loaded struct should match saved struct")
    }
    
    func testRemove() {
        let testValue = "To be removed"
        userDefaultService.save(key: testKey, value: testValue)
        
        userDefaultService.remove(key: testKey)
        let loadedValue: String = userDefaultService.load(key: testKey, defaultValue: "Default")
        XCTAssertEqual(loadedValue, "Default", "Value should be removed and return default")
    }
}
