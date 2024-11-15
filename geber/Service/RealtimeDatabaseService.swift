//
//  RealtimeDatabaseService.swift
//  geber
//
//  Created by Vikri Yuwi on 14/11/24.
//
import SwiftUI
import FirebaseDatabase

class RealtimeDatabaseService {
    @Published var helpRequests: HelpRequestModel? = nil
    
    private let ref = Database.database().reference()
    
    
}
