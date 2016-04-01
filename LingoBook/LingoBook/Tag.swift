//
//  Tag.swift
//  LingoBook
//
//  Created by Connor Goddard on 23/03/2016.
//  Copyright © 2016 Connor Goddard. All rights reserved.
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
