//
//  VehicleInformationPage.swift
//  geber
//
//  Created by Vikri Yuwi on 1/10/24.
//

import SwiftUI

struct VehicleInformationPage: View {
    @State private var showingNameSheet = false
    @State private var showingNewVehicleSheet = false
    
    @State private var showDeleteAlert = false
    @State var showEmptyAlert = false
    
    @StateObject private var viewModel = VehicleInformationViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundTheme
                    .ignoresSafeArea()
                VStack {
                    List {
                        Section {
                            HStack(alignment:.center) {
                                Spacer()
                                Text("Personal data")
                                    .font(.largeTitle.bold())
                                Spacer()
                            }
                            .listRowBackground(Color.backgroundTheme)
                        }
                        
                        Section(header: Text("Personal information")) {
                            Button{
                                showingNameSheet.toggle()
                            } label: {
                                HStack {
                                    Text("Name")
                                    Spacer()
                                    Text(viewModel.username)
                                        .foregroundStyle(viewModel.username != viewModel.usernameDefault ? .primary : .secondary)
                                    Image(systemName: "chevron.right")
                                }
                            }
                        }
                        
                        Section(header: Text("Vehicle in user")) {
                            if viewModel.vehicleActive.Model != viewModel.vehicleAttributeActiveDefault {
                                HStack(alignment:.top) {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text(viewModel.vehicleActive.Model)
                                                .font(.title3.bold())
                                            Text(viewModel.vehicleActive.Color)
                                                .font(.footnote)
                                                .foregroundStyle(.white)
                                                .padding(.vertical, 4)
                                                .padding(.horizontal, 8)
                                                .background(.black)
                                                .cornerRadius(10)
                                        }
                                        Text(viewModel.vehicleActive.PlateNumber)
                                    }
                                    Spacer()
                                    Button {
                                        viewModel.deleteVehicleActive()
                                    } label: {
                                        Image(systemName: "xmark")
                                    }
                                }
                                .padding(.vertical,10)
                                .listRowBackground(Color.accent)
                                .foregroundStyle(.textDark)
                            } else {
                                Text("No active vehicle")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        Section {
                            Text("Click on a vehicle below to set it as your active vehicle")
                                .foregroundStyle(.secondary)
                                .listRowBackground(Color.backgroundTheme)
                        }
                        Section(header: Text("VEHICLE LIST")) {
                            ForEach(viewModel.vehicles, id:\.self) { vehicle in
                                if vehicle.PlateNumber != viewModel.vehicleActive.PlateNumber {
                                    VehicleListItem(vehicle: vehicle)
                                        .swipeActions(edge: .trailing) {
                                            Button {
                                                showDeleteAlert = true
                                            } label: {
                                                Image(systemName: "trash")
                                            }
                                            .tint(.red)
                                        }
                                        .alert(isPresented: $showDeleteAlert) {
                                            Alert(
                                                title: Text("Delete \(vehicle.Model)?"),
                                                message: Text("Are you sure you want to delete \(vehicle.Model) \(vehicle.PlateNumber)?"),
                                                primaryButton: .destructive(Text("Delete")) {
                                                    viewModel.deleteVehicle(vehicle)
                                                },
                                                secondaryButton: .cancel()
                                            )
                                        }
                                        .environmentObject(viewModel)
                                }
                            }
                            Button {
                                showingNewVehicleSheet.toggle()
                            } label: {
                                Text("+ add vehicle")
                                    .font(.body.bold())
                                    .foregroundStyle(.blue)
                            }
                        }
                        .background(.clear)
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .frame(width: .infinity, height: .infinity)
        }
        .frame(width: .infinity, height: .infinity)
        .navigationViewStyle(.stack)
        .toolbarBackground(.backgroundTheme)
        
        .sheet(isPresented: $showingNameSheet) {
            NameSheetView(showingNameSheet: $showingNameSheet)
                .presentationDetents([.medium,.large])
                .environmentObject(viewModel)
        }
        .sheet(isPresented: $showingNewVehicleSheet) {
            NewVehicleSheetView(showingNewVehicleSheet: $showingNewVehicleSheet)
                .presentationDetents([.medium,.large])
                .environmentObject(viewModel)
        }
    }
}

#Preview {
    VehicleInformationPage()
}
