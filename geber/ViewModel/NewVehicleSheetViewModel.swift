//
//  NewVehicleSheetViewModel.swift
//  geber
//
//  Created by Vikri Yuwi on 3/10/24.
//

import SwiftUI

class NewVehicleSheetViewModel: ObservableObject {
    private let dataSource = SwiftDataService.shared
    
    func saveVehicle(_ model: String, _ plateNumber: String, _ color: VehicleColor) {
        let vehicle = VehicleModel(Model: model, PlateNumber: plateNumber, Color: color)
        dataSource.addVehicle(vehicle)
    }
}
