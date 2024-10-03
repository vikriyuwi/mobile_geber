//
//  NewVehicleSheetView.swift
//  geber
//
//  Created by Vikri Yuwi on 2/10/24.
//

import SwiftUI

struct NewVehicleSheetView: View {
    @StateObject var viewModel = NewVehicleSheetViewModel()
    
    @Binding var showingNewVehicleSheet: Bool
    
    @State var vehicleModel: String = ""
    @State var vehiclePlateNumber: String = ""
    @State var vehicleColor: VehicleColor = VehicleColor.white
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    resetForm()
                    showingNewVehicleSheet.toggle()
                } label: {
                    Text("Cancel")
                        .foregroundStyle(.red)
                }
                Spacer()
                Button {
                    viewModel.saveVehicle(vehicleModel, vehiclePlateNumber, vehicleColor)
                    
                    resetForm()
                    showingNewVehicleSheet.toggle()
                } label: {
                    Text("Done")
                        .fontWeight(.bold)
                        .foregroundStyle(.blue)
                }
            }
            .padding(.horizontal,20)
            .padding(.top,20)
            Form {
                Section(header: Text("VEHICLE INFORMATION")) {
                    TextField("Vehicle model", text: $vehicleModel)
                        .background(.backgroundGroup)
                    TextField("Plate number", text: $vehiclePlateNumber)
                        .background(.backgroundGroup)
                    Picker("Color", selection: $vehicleColor) {
                        Text("Black").tag(VehicleColor.black)
                        Text("Blue").tag(VehicleColor.blue)
                        Text("Brown").tag(VehicleColor.brown)
                        Text("Green").tag(VehicleColor.green)
                        Text("Grey").tag(VehicleColor.grey)
                        Text("Orange").tag(VehicleColor.orange)
                        Text("Pink").tag(VehicleColor.pink)
                        Text("Purple").tag(VehicleColor.purple)
                        Text("Red").tag(VehicleColor.red)
                        Text("Silver").tag(VehicleColor.silver)
                        Text("White").tag(VehicleColor.white)
                        Text("Yellow").tag(VehicleColor.yellow)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            
        }
        .background(.backgroundTheme)
    }
    
    func resetForm() {
        vehicleModel = ""
        vehiclePlateNumber = ""
        vehicleColor = .white
    }
}

#Preview {
    NewVehicleSheetView(showingNewVehicleSheet: .constant(true))
}
