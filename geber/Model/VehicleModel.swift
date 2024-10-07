//
//  VehicleModel.swift
//  geber
//
//  Created by Vikri Yuwi on 2/10/24.
//
import Foundation
import SwiftData

@Model
class VehicleModel: Identifiable {
    var model: String
    @Attribute(.unique) var plateNumber: String
    var color: String
    init(model: String, plateNumber: String, color: String) {
        self.model = model
        self.plateNumber = plateNumber
        self.color = color
    }
}
