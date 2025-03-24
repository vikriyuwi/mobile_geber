import Foundation
@testable import geber

class MockUserDefaultService: UserDefaultServiceProtocol {
    var savedData: [String: Any] = [:]
    
    func save<T>(key: String, value: T) {
        savedData[key] = value
    }
    
    func load<T>(key: String, defaultValue: T) -> T {
        return savedData[key] as? T ?? defaultValue
    }
    
    func remove(key: String) {
        savedData.removeValue(forKey: key)
    }
}
