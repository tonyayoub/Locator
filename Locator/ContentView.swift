//
//  ContentView.swift
//  Locator
//
//  Created by Tony Ayoub on 15-03-2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var viewModel: LocationViewModel
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Update.time, ascending: true)],
        animation: .none)
    private var updates: FetchedResults<Update>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(updates) { update in
                    VStack(alignment: .leading) {
                        Text("\(update.time ?? Date(), formatter: itemFormatter)")
                            .font(.caption)
                        Text("Latitude: \(update.latitude)")
                            .font(.caption)
                        Text("Longitude: \(update.longitude)")
                            .font(.caption)
                        Text("\(update.comment ?? "")")
                            .font(.caption)
                            .foregroundStyle(update.comment == "Foreground" ? Color.green : Color.red)
                    }
                }
            }
            .navigationTitle("Updates")
            .toolbar {
                Button(action: clearUpdates) {
                    Label("Clear", systemImage: "trash")
                }
            }
        }
        .task {
            viewModel.requestPermissionAndStartUpdates()
        }
    }
    
    private func clearUpdates() {
        viewModel.deleteAll()
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .none
    formatter.timeStyle = .medium
    return formatter
}()

