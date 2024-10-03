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
    var Model: String
    @Attribute(.unique) var PlateNumber: String
    var Color: String
    init(Model: String, PlateNumber: String, Color: String) {
        self.Model = Model
        self.PlateNumber = PlateNumber
        self.Color = Color
    }
}
