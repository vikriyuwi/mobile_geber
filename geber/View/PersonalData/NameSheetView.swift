//
//  NameSheetView.swift
//  geber
//
//  Created by Vikri Yuwi on 2/10/24.
//
import SwiftUI

struct NameSheetView: View {
    @EnvironmentObject var viewModel: VehicleInformationViewModel
    
    @Binding var showingNameSheet: Bool
    @State var username: String = ""
    
    @State private var showNameInvalid: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    username = ""
                    showingNameSheet.toggle()
                } label: {
                    Text("Cancel")
                        .foregroundStyle(.red)
                }
                Spacer()
                Button {
                    if !username.isEmpty {
                        viewModel.saveUsername(username)
                        username = ""
                        showingNameSheet.toggle()
                    } else {
                        showNameInvalid.toggle()
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
                Section(header: Text("New name")) {
                    TextField("Name", text: $username)
                        .background(.backgroundGroup)
                }
            }
            .scrollContentBackground(.hidden)
            .alert(isPresented: $showNameInvalid) {
                Alert(
                    title: Text("Invalid name"),
                    message: Text("Make sure you filled the field"),
                    dismissButton: .default(Text("Ok"))
                )
            }
        }
        .background(.backgroundTheme)
    }
}

#Preview() { NameSheetView(showingNameSheet: .constant(true)) }
