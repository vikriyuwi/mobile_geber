//
//  VehicleItemView.swift
//  geber
//
//  Created by Vikri Yuwi on 2/10/24.
//
import SwiftUI

struct VehicleListItem: View {
    @EnvironmentObject var viewModel: VehicleInformationViewModel
    @State var vehicle: VehicleModel
    
    var body: some View {
        Button {
            viewModel.saveVehicleActive(vehicle)
        } label: {
            HStack(alignment:.top) {
                VStack(alignment: .leading) {
                    HStack {
                        Text(vehicle.Model)
                            .font(.title3.bold())
                        Text(vehicle.Color)
                            .font(.footnote)
                            .foregroundStyle(.white)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .background(.black)
                            .cornerRadius(10)
                    }
                    Text(vehicle.PlateNumber)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
        }
    }
}

#Preview {
    VehicleListItem(vehicle: VehicleModel(Model: "Mio", PlateNumber: "N1234G", Color: "Black"))
}
