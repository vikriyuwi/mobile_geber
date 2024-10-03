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
                                    Text("Fikri Yuwi")
                                    Image(systemName: "chevron.right")
                                }
                            }
                        }
                        
                        Section(header: Text("Vehicle in user")) {
                            HStack(alignment:.top) {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("Aerox")
                                            .font(.title3.bold())
                                        Text("black")
                                            .font(.footnote)
                                            .foregroundStyle(.white)
                                            .padding(.vertical, 4)
                                            .padding(.horizontal, 8)
                                            .background(.black)
                                            .cornerRadius(10)
                                    }
                                    Text("B 2103 UB")
                                }
                                Spacer()
                            }
                            .padding(.vertical,10)
                            .listRowBackground(Color.accent)
                            .foregroundStyle(.textDark)
                        }
                        Section(header: Text("VEHICLE LIST")) {
                            ForEach(viewModel.vehicles, id:\.self) { vehicle in
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
                .presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $showingNewVehicleSheet) {
            NewVehicleSheetView(showingNewVehicleSheet: $showingNewVehicleSheet)
                .presentationDetents([.medium, .large])
        }
    }
}

#Preview {
    VehicleInformationPage()
}
