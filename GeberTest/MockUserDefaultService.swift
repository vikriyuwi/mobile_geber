//
//  MockUserDefaultService.swift
//  geber
//
//  Created by Vikri Yuwi on 05/01/25.
//

import XCTest
@testable import geber

class MockUserDefaultService: UserDefaultServiceProtocol {
    private var storage: [String: Data] = [:]
    
    func save<T: Codable>(key: String, value: T) {
        let data = try? JSONEncoder().encode(value)
        storage[key] = data
    }
    
    func load<T: Codable>(key: String, defaultValue: T) -> T {
        guard let data = storage[key], let decoded = try? JSONDecoder().decode(T.self, from: data) else {
            return defaultValue
        }
        return decoded
    }
    
    func remove(key: String) {
        storage.removeValue(forKey: key)
    }
}
