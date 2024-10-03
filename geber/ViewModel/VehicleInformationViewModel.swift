//
//  VehicleInformationViewModel.swift
//  geber
//
//  Created by Vikri Yuwi on 2/10/24.
//
import SwiftUI
import Combine

class VehicleInformationViewModel: ObservableObject {
    @Published var vehicles: [VehicleModel] = []
    private var cancellables = Set<AnyCancellable>()
    
    private let dataSource = SwiftDataService.shared
    
    init() {
        dataSource.$vehicles
            .assign(to: &$vehicles)
    }
    
    func loadVehicle() {
        dataSource.fetchVehicle()
    }
    
    func deleteVehicle(_ vehicle: VehicleModel) {
        dataSource.removeVehicle(vehicle)
    }
}
