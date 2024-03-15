//
//  LocatorApp.swift
//  Locator
//
//  Created by Tony Ayoub on 15-03-2024.
//

import SwiftUI

@main
struct LocatorApp: App {
    @Environment(\.scenePhase) private var scenePhase
    
    let persistenceController = PersistenceController.shared
    @StateObject var viewModel = LocationViewModel()
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(viewModel)
                .onChange(of: scenePhase) { _, newPhase in
                    switch newPhase {
                    case .background:
                        viewModel.setGeoFence()
                        print("setup geofencing region... ")
                    default:
                        break
                    }
                }
        }
    }
}
