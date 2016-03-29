//
//  OriginPhrase.swift
//  LingoBook
//
//  Created by Connor Goddard on 23/03/2016.
//  Copyright © 2016 Connor Goddard. All rights reserved.
//

import Foundation
import CoreData


class OriginPhrase: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    func addNewTranslation(newTranslation: TranslatedPhrase) {
        
        let translations = self.translations!.mutableCopy() as! NSMutableSet
        translations.addObject(newTranslation)
        self.translations = translations as NSSet
        
    }

}
