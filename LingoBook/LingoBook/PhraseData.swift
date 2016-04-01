//
//  PhraseData.swift
//  LingoBook
//
//  Created by Connor Goddard on 01/04/2016.
//  Copyright © 2016 Connor Goddard. All rights reserved.
//

import Foundation

struct PhraseData {
    
    var originPhrase: String
    var translatedPhrase: String
    var tags: [String]
    var note: String
    var objectURI: NSURL?
    
    init() {
        
        self.originPhrase = ""
        self.translatedPhrase = ""
        self.tags = [String]()
        self.note = ""
        
    }
    
    init(originPhrase: String, translatedPhrase: String, tags: [String], note: String) {
        
        self.originPhrase = originPhrase
        self.translatedPhrase = translatedPhrase
        self.tags = tags
        self.note = note
        
    }
    
}