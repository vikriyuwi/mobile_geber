//
//  UserDefaultService.swift
//  geber
//
//  Created by Vikri Yuwi on 3/10/24.
//
import Foundation

extension Notification.Name {
    static let userDefaultsDidChange = Notification.Name("userDefaultsDidChange")
}

class UserDefaultService: UserDefaultServiceProtocol {
    private let userDefaults = UserDefaults.standard
    
    func save<T: Codable>(key: String, value: T) {
        let encoder = JSONEncoder()
        if let encodedValue = try? encoder.encode(value) {
            userDefaults.set(encodedValue, forKey: key)
            NotificationCenter.default.post(name: .userDefaultsDidChange, object: key)
        }
    }
    
    func load<T: Codable>(key: String, defaultValue: T) -> T {
        guard let data = userDefaults.data(forKey: key) else {
            return defaultValue
        }
        let decoder = JSONDecoder()
        return (try? decoder.decode(T.self, from: data)) ?? defaultValue
    }
    
    func remove(key: String) {
        userDefaults.removeObject(forKey: key)
        NotificationCenter.default.post(name: .userDefaultsDidChange, object: key)
    }
}
