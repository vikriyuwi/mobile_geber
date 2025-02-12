import XCTest
@testable import geber

class MockUserDefaultServiceVehicle: UserDefaultServiceProtocol {
    var savedValues: [String: Any] = [:]
    var removedKeys: [String] = []
    
    func save<T: Codable>(key: String, value: T) {
        savedValues[key] = value
    }
    
    func load<T: Codable>(key: String, defaultValue: T) -> T {
        return savedValues[key] as? T ?? defaultValue
    }
    
    func remove(key: String) {
        removedKeys.append(key)
        savedValues.removeValue(forKey: key)
    }
}
