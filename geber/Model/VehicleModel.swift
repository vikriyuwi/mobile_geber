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
    var PlateNumber: String
    var Color: VehicleColor.RawValue
    init(Model: String, PlateNumber: String, Color: VehicleColor) {
        self.Model = Model
        self.PlateNumber = PlateNumber
        self.Color = Color.rawValue
    }
}

enum VehicleColor: String, Codable, Identifiable, CaseIterable {
    case black, blue, brown, green, grey, orange, pink, purple, red, silver, white, yellow
    var id: Self { self }
    var description: String {
        switch self {
            case .black:
                return "Blue"
            case .blue:
                return "Blue"
            case .brown:
                return "Brown"
            case .green:
                return "Green"
            case .grey:
                return "Grey"
            case .orange:
                return "Orange"
            case .pink:
                return "Pink"
            case .purple:
                return "Purple"
            case .red:
                return "Red"
            case .silver:
                return "Silver"
            case .white:
                return "White"
            case .yellow:
                return "Yellow"
        }
    }
}
