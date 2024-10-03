//
//  VehicleSwiftDataService.swift
//  geber
//
//  Created by Vikri Yuwi on 2/10/24.
//

import SwiftData
import Foundation

class SwiftDataService {
    @Published var vehicles: [VehicleModel] = []
    
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    @MainActor
    static let shared = SwiftDataService()
    
    @MainActor
    private init() {
        // Change isStoredInMemoryOnly to false if you would like to see the data persistance after kill/exit the app
        
        let schema = Schema([
            VehicleModel.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        self.modelContainer = try! ModelContainer(for: schema, configurations: modelConfiguration)
        self.modelContext = modelContainer.mainContext
        self.fetchVehicle()
        
        NotificationCenter.default.addObserver(self, selector: #selector(contextObjectDidChange), name: .NSManagedObjectContextObjectsDidChange, object: modelContext)
    }
    
    @objc private func contextObjectDidChange(notification: Notification) {
        self.fetchVehicle()
    }
    
    func fetchVehicle() {
        do {
            self.vehicles = try modelContext.fetch(FetchDescriptor<VehicleModel>())
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func addVehicle(_ vehicle: VehicleModel) {
        modelContext.insert(vehicle)
        do {
            try modelContext.save()
            self.fetchVehicle()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func removeVehicle(_ vehicle: VehicleModel) {
        modelContext.delete(vehicle)
        do {
            try modelContext.save()
            self.fetchVehicle()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
