//
//  Place+CoreDataProperties.swift
//  ToDo
//
//  Created by Andrew Burns on 12/28/15.
//  Copyright © 2015 Andrew Burns. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Place {

    @NSManaged var title: String?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var subtitle: String?
    @NSManaged var toDoItem: NSSet?
}
