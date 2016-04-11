//
//  Tag.swift
//  LingoBook
//
//  Student No: 110024253
//

import Foundation
import CoreData


class Tag: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    func addPhrase(newPhrase: OriginPhrase) {
        
        let originPhrases = self.originWords!.mutableCopy() as! NSMutableSet
        
        // Sets should remove duplicates automatically?
        originPhrases.addObject(newPhrase)
        
        self.originWords = originPhrases as NSSet
        
    }

}
