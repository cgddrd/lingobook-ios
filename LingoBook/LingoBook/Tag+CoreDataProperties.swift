//
//  Tag+CoreDataProperties.swift
//  LingoBook
//
//  Student No: 110024253
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Tag
{

    @NSManaged var name: String?
    @NSManaged var originWords: NSSet?

}
