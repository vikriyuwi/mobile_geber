//
//  NameSheetView.swift
//  geber
//
//  Created by Vikri Yuwi on 2/10/24.
//
import SwiftUI

struct NameSheetView: View {
    @Binding var showingNameSheet: Bool
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    showingNameSheet.toggle()
                } label: {
                    Text("Cancel")
                        .foregroundStyle(.red)
                }
                Spacer()
                Button {
                    showingNameSheet.toggle()
                } label: {
                    Text("Done")
                        .fontWeight(.bold)
                        .foregroundStyle(.blue)
                }
            }
            .padding(.horizontal,20)
            .padding(.top,20)
            Form {
                Section(header: Text("Your name")) {
                    TextField("Name", text: .constant(""))
                        .background(.backgroundGroup)
                }
            }
            .scrollContentBackground(.hidden)
            
        }
        .background(.backgroundTheme)
    }
}

#Preview() { NameSheetView(showingNameSheet: .constant(true)) }
