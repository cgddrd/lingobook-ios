//
//  TranslatedPhrase+CoreDataProperties.swift
//  LingoBook
//
//  Created by Connor Goddard on 23/03/2016.
//  Copyright © 2016 Connor Goddard. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension TranslatedPhrase {

    @NSManaged var locale: String?
    @NSManaged var textValue: String?
    @NSManaged var origin: NSManagedObject?

}
