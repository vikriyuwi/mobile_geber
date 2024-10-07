//
//  NewVehicleSheetView.swift
//  geber
//
//  Created by Vikri Yuwi on 2/10/24.
//

import SwiftUI

struct NewVehicleSheetView: View {
    @EnvironmentObject var viewModel: VehicleInformationViewModel
    
    @Binding var showingNewVehicleSheet: Bool
    
    @State private var vehicleModel: String = ""
    @State private var vehiclePlateNumber: String = ""
    @State private var vehicleColor: String = "Placeholder"
    
    @State private var showFormInvalid: Bool = false
    
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
                    if isNotEmpty() {
                        viewModel.saveVehicle(vehicleModel, vehiclePlateNumber, vehicleColor)
                        
                        resetForm()
                        showingNewVehicleSheet.toggle()
                    } else {
                        showFormInvalid.toggle()
                    }
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
                    TextField("Plate number", text: $vehiclePlateNumber)
                    Picker("Color", selection: $vehicleColor) {
                        Text("Select color").tag("Placeholder")
                        Text("Black").tag("Black")
                        Text("Blue").tag("Blue")
                        Text("Brown").tag("Brown")
                        Text("Green").tag("Green")
                        Text("Grey").tag("Grey")
                        Text("Orange").tag("Orange")
                        Text("Pink").tag("Pink")
                        Text("Purple").tag("Purple")
                        Text("Red").tag("Red")
                        Text("Silver").tag("Silver")
                        Text("White").tag("White")
                        Text("Yellow").tag("Yellow")
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .alert(isPresented: $showFormInvalid) {
                Alert(
                    title: Text("Invalid form"),
                    message: Text("Make sure you filled all fields"),
                    dismissButton: .default(Text("Ok"))
                )
            }
        }
        .background(.backgroundTheme)
    }
    
    func resetForm() {
        vehicleModel = ""
        vehiclePlateNumber = ""
        vehicleColor = ""
    }
    
    func isNotEmpty() -> Bool {
        if (!vehicleModel.isEmpty && !vehiclePlateNumber.isEmpty) && vehicleColor != "Placeholder" {
            return true
        }
        return false
    }
}

#Preview {
    NewVehicleSheetView(showingNewVehicleSheet: .constant(true))
}
