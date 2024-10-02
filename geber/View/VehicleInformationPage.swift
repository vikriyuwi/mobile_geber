//
//  VehicleInformationPage.swift
//  geber
//
//  Created by Vikri Yuwi on 1/10/24.
//

import SwiftUI

struct VehicleInformationPage: View {
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
                            VehicleListItem()
                            VehicleListItem()
                            Button {
                                
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
    }
}

struct VehicleListItem: View {
    var body: some View {
        Button {
            
        } label: {
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
        }
    }
}

#Preview {
    VehicleInformationPage()
}
