//
//  geberApp.swift
//  geber
//
//  Created by win win on 20/9/24.
//

import SwiftUI
import SwiftData
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct geberApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([VehicleModel.self]) // Register the model
        let config = ModelConfiguration(isStoredInMemoryOnly: false) // Persistent storage
        return try! ModelContainer(for: schema, configurations: config)
    }()
    
    @StateObject var networkMonitor = NetworkManager()
    var body: some Scene {
        WindowGroup {
            HelpPage()
                .environmentObject(networkMonitor)
                .modelContainer(sharedModelContainer)
        }
    }
}
