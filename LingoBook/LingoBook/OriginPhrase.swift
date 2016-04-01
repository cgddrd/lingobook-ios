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
    
    func addTranslation(newTranslation: TranslatedPhrase) {
        
        let translations = self.translations!.mutableCopy() as! NSMutableSet
        
        translations.removeAllObjects()
        
        translations.addObject(newTranslation)
        self.translations = translations as NSSet
        
    }
    
    func addTagByName(newTagName: String) {
        
        let newTag = Tag()
        newTag.name = newTagName
        self.addTag(newTag)
        
    }
    
    func addTag(newTag: Tag) {
        
        let tags = self.tags!.mutableCopy() as! NSMutableSet
        tags.addObject(newTag)
        self.tags = tags as NSSet
        
    }
    
    // Temp method to only return the first translated phrase.
    func getFirstTranslation() -> TranslatedPhrase? {
        
        if self.translations != nil {
            
            if let firstTranslation = self.translations?.allObjects.first as? TranslatedPhrase {
                
                return firstTranslation
                
            }
            
        }
        
        return nil
        
    }

}
