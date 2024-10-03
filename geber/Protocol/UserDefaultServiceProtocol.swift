//
//  UserDefaultServiceProtocol.swift
//  geber
//
//  Created by Vikri Yuwi on 3/10/24.
//

protocol UserDefaultServiceProtocol {
    func save<T: Codable>(key: String, value: T)
    func load<T: Codable>(key: String, defaultValue: T) -> T
    func remove(key: String)
}
