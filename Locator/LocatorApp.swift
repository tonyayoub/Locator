//
//  LocatorApp.swift
//  Locator
//
//  Created by Tony Ayoub on 15-03-2024.
//

import SwiftUI

@main
struct LocatorApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
