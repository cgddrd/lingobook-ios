//
//  PhraseData.swift
//  LingoBook
//
//  Created by Connor Goddard on 01/04/2016.
//  Copyright © 2016 Connor Goddard. All rights reserved.
//

import Foundation

struct PhraseModel {
    
    var originPhraseText: String
    var translatedPhrases: [TranslationModel]
    var tags: [String]
    var note: String
    //var objectURI: NSURL?
    
    init() {
        
        self.originPhraseText = ""
        self.translatedPhrases = [TranslationModel]()
        self.tags = [String]()
        self.note = ""
        
    }
    
    init(existingPhrase: OriginPhrase) {
        
        self.originPhraseText = existingPhrase.textValue!
        
        self.translatedPhrases = [TranslationModel(existingTranslation: (existingPhrase.getFirstTranslation())!)]
        
        self.note = existingPhrase.note!
        
        if let existingTags = existingPhrase.tags!.allObjects as? [Tag] {
            
            self.tags = existingTags.map({ (tag: Tag) -> String in return tag.name! }) as [String]
            
        } else {
            
            self.tags = [String]()
            
        }
        
        //self.objectURI = existingPhrase.objectID.URIRepresentation()
        
    }
    
}

struct TranslationModel {
    
    var translatedText: String
    var locale: String
    
    init() {
        
        self.translatedText = ""
        self.locale = ""

    }
    
    init(translatedText: String, locale: String) {
        
        self.translatedText = translatedText
        self.locale = locale
    
    }
    
    init(existingTranslation: TranslatedPhrase) {
        
        self.translatedText = existingTranslation.textValue!
        self.locale = existingTranslation.locale!
        
    }
}