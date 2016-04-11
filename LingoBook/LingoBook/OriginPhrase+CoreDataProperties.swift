//
//  OriginPhrase+CoreDataProperties.swift
//  LingoBook
//
//  Student No: 110024253
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension OriginPhrase {

    @NSManaged var note: String?
    @NSManaged var textValue: String?
    @NSManaged var type: String?
    @NSManaged var tags: NSSet?
    @NSManaged var translations: NSSet?

}
