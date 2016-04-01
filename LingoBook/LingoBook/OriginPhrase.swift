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
    
    func addNewTag(newTag: Tag) {
        
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
    
    func toPhraseData() -> PhraseData {
        
        var test = PhraseData()
        
        test.originPhrase = self.textValue!
        test.translatedPhrase = (self.getFirstTranslation()?.textValue)!
        test.note = self.note!
        
        if let blah = self.tags?.allObjects as? [Tag] {
            
             test.tags = blah.map({ (tag: Tag) -> String in return tag.name! }) as [String]
            
        }
        
        test.objectURI = self.objectID.URIRepresentation()
        
        return test
       
    }

}
