import SwiftData
import Foundation

protocol SwiftDataServiceProtocol {
    func add<T: PersistentModel>(_ object: T) async
    func fetch<T: PersistentModel>() async -> [T]
    func remove<T: PersistentModel>(_ object: T) async
    func removeAll<T: PersistentModel>(ofType type: T.Type) async
}
