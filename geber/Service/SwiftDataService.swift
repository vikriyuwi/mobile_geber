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
    @Published var helpRequests: [HelpRequestModel] = []
    
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    @MainActor
    static let shared = SwiftDataService()
    
    @MainActor
    public init() {
        // Change isStoredInMemoryOnly to false if you would like to see the data persistance after kill/exit the app
        
        let schema = Schema([
            VehicleModel.self,
            HelpRequestModel.self
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        self.modelContainer = try! ModelContainer(for: schema, configurations: modelConfiguration)
        self.modelContext = modelContainer.mainContext
        
        self.fetchVehicle()
        self.fetchHelpRequests()
        
        NotificationCenter.default.addObserver(self, selector: #selector(contextObjectDidChange), name: .NSManagedObjectContextObjectsDidChange, object: modelContext)
    }
    
    @objc private func contextObjectDidChange(notification: Notification) {
        self.fetchVehicle()
        self.fetchHelpRequests()
    }
    
    func fetchVehicle() {
        do {
            self.vehicles = try modelContext.fetch(FetchDescriptor<VehicleModel>())
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func fetchHelpRequests() {
        do {
            self.helpRequests = try modelContext.fetch(FetchDescriptor<HelpRequestModel>())
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
    
    func addHelpRequest(_ helpRequest: HelpRequestModel) {
        modelContext.insert(helpRequest)
        do {
            try modelContext.save()
            self.fetchHelpRequests()
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
    
    func removeAllHelpRequest() {
        let fetchDescriptor = FetchDescriptor<HelpRequestModel>()
        
        do {
            let helpRequests = try modelContext.fetch(fetchDescriptor)
            
            for helpRequest in helpRequests {
                modelContext.delete(helpRequest)
            }
            
            try modelContext.save()  // Save changes to the context
            self.fetchHelpRequests() // Re-fetch remaining vehicles (none if all are deleted)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
