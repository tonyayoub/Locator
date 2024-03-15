//
//  DataManager.swift
//  Locator
//
//  Created by Tony Ayoub on 15-03-2024.
//

import CoreData
import CoreLocation

class DataManager {
    static let shared = DataManager()
    
    var context: NSManagedObjectContext {
        PersistenceController.shared.container.viewContext
    }
    
    func saveLocation(time: Date, latitude: Double, longitude: Double, comment: String) {
        let update = Update(context: context)
        update.time = time
        update.latitude = latitude
        update.longitude = longitude
        update.comment = comment
        
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func deleteAllUpdates() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Update.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        context.performAndWait {
            do {
                try context.execute(deleteRequest)
                try context.save()
                context.reset() // Resets the context to ensure it re-fetches data
            } catch {
                print("Error deleting all updates: \(error), \(error.localizedDescription)")
            }
        }
    }
}

