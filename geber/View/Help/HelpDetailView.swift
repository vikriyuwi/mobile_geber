//
//  HelpDetailView.swift
//  geber
//
//  Created by Vikri Yuwi on 4/10/24.
//

import SwiftUI

struct HelpDetailView: View {
    @EnvironmentObject var viewModel: HelpViewModel
    
    var body: some View {
        HStack(alignment:.top) {
            VStack(alignment: .leading) {
                if viewModel.username == viewModel.usernameDefault {
                    HStack {
                        Image(systemName: "xmark.circle")
                            .foregroundStyle(.red)
                        Text("Username is empty")
                    }
                    NavigationLink(destination: {
                        VehicleInformationPage()
                    }, label: {
                        HStack {
                            Spacer()
                            Text("SET USERNAME")
                                .padding(20)
                                .foregroundStyle(.textDark)
                            Spacer()
                        }
                    })
                    .buttonStyle(.borderedProminent)
                    .cornerRadius(20)
                } else if viewModel.vehicleActive.model == viewModel.vehicleAttributeActiveDefault {
                    HStack {
                        Image(systemName: "xmark.circle")
                            .foregroundStyle(.red)
                        Text("No active vehicle")
                    }
                    NavigationLink(destination: {
                        VehicleInformationPage()
                    }, label: {
                        HStack {
                            Spacer()
                            Text("SET ACTIVE VEHICLE")
                                .padding(20)
                                .foregroundStyle(.textDark)
                            Spacer()
                        }
                    })
                    .buttonStyle(.borderedProminent)
                    .cornerRadius(20)
                } else {
                    NavigationLink(destination: {
                        VehicleInformationPage()
                    }, label: {
                        HStack(alignment: .center) {
                            VStack(alignment: .leading) {
                                HStack(alignment: .top) {
                                    Text(viewModel.vehicleActive.model)
                                        .font(.title3.bold())
                                    Text(viewModel.vehicleActive.color)
                                        .font(.footnote)
                                        .foregroundStyle(Color.textDark)
                                        .padding(.vertical, 4)
                                        .padding(.horizontal, 8)
                                        .background(.primary)
                                        .cornerRadius(10)
                                }
                                Text(viewModel.vehicleActive.plateNumber)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding(20)
                        .background(Color.backgroundTheme)
                        .cornerRadius(20)
                    })
                    
                    Button {
                        viewModel.sendHelpRequest()
                    } label: {
                        HStack {
                            Spacer()
                            Text("SEND HELP")
                                .padding(20)
                                .foregroundStyle(viewModel.currentNearestLocation != nil ? .textDark : .secondary)
                            Spacer()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .cornerRadius(20)
                    .padding(.top,4)
                    .disabled(viewModel.currentNearestLocation != nil ? false : true)
                }
            }
        }
        .padding(20)
        .background(.backgroundGroup)
        .cornerRadius(40)
    }
}

#Preview {
    HelpDetailView()
        .environmentObject(HelpViewModel())
}
