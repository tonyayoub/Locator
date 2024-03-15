//
//  Update+CoreDataProperties.swift
//  Locator
//
//  Created by Tony Ayoub on 15-03-2024.
//
//

import Foundation
import CoreData


extension Update {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Update> {
        return NSFetchRequest<Update>(entityName: "Update")
    }

    @NSManaged public var time: Date?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var comment: String?

}

extension Update : Identifiable {

}
