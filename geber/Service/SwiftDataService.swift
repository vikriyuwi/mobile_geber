import SwiftData
import Foundation

@MainActor
class SwiftDataService: SwiftDataServiceProtocol {
    static let shared = SwiftDataService()
    
    private let container: ModelContainer
    private let context: ModelContext
    
    private init() {
        do {
            container = try ModelContainer()
            context = container.mainContext
        } catch {
            fatalError("Failed to initialize SwiftData container: \(error)")
        }
    }
    
    // Add an object
    func add<T: PersistentModel>(_ object: T) {
        context.insert(object)
        saveContext()
    }
    
    // Fetch all objects of a type
    func fetch<T: PersistentModel>() -> [T] {
        let fetchDescriptor = FetchDescriptor<T>()
        return (try? context.fetch(fetchDescriptor)) ?? []
    }
    
    // Remove a specific object
    func remove<T: PersistentModel>(_ object: T) {
        context.delete(object)
        saveContext()
    }
    
    // Remove all objects of a type
    func removeAll<T: PersistentModel>(ofType type: T.Type) {
        let objects = fetch() as [T]
        objects.forEach { context.delete($0) }
        saveContext()
    }
    
    // Save Context
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}
