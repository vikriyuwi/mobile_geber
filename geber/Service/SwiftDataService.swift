import SwiftData
import Foundation

@MainActor
class SwiftDataService {
    static let shared = SwiftDataService()
    
    private let container: ModelContainer
    private let context: ModelContext
    
    private init() {
        do {
            container = try ModelContainer(for: VehicleModel.self, HelpRequestModel.self)
            context = container.mainContext
        } catch {
            fatalError("Failed to initialize SwiftData container: \(error)")
        }
    }
    
    // Fetch Vehicles
    func fetchVehicle() -> [VehicleModel] {
        let fetchDescriptor = FetchDescriptor<VehicleModel>()
        return (try? context.fetch(fetchDescriptor)) ?? []
    }
    
    // Fetch Help Requests
    func fetchHelpRequests() -> [HelpRequestModel] {
        let fetchDescriptor = FetchDescriptor<HelpRequestModel>()
        return (try? context.fetch(fetchDescriptor)) ?? []
    }
    
    // Add Vehicle
    func addVehicle(_ vehicle: VehicleModel) {
        context.insert(vehicle)
        saveContext()
    }
    
    // Add Help Request
    func addHelpRequest(_ helpRequest: HelpRequestModel) {
        context.insert(helpRequest)
        saveContext()
    }
    
    // Remove Vehicle
    func removeVehicle(_ vehicle: VehicleModel) {
        context.delete(vehicle)
        saveContext()
    }
    
    // Remove All Help Requests
    func removeAllHelpRequest() {
        let requests = fetchHelpRequests()
        requests.forEach { context.delete($0) }
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
