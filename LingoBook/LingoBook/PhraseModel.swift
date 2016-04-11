//
//  PhraseModel.swift
//  LingoBook
//
//  Student No: 110024253
//

import Foundation

// Model struct providing temporary representation for a phrase entity whilst working outside of Core Data.
struct PhraseModel {
    
    var originPhraseText: String
    var translatedPhrases: [TranslationModel]
    var tags: [String]
    var note: String
    var type: String
    
    init() {
        
        self.originPhraseText = ""
        self.translatedPhrases = [TranslationModel]()
        self.tags = [String]()
        self.note = ""
        self.type = ""
        
    }
    
    // Convenience constructor to convert from an OriginPhrase model.
    init(existingPhrase: OriginPhrase) {
        
        self.originPhraseText = existingPhrase.textValue!
        
        self.translatedPhrases = [TranslationModel(existingTranslation: (existingPhrase.getFirstTranslation())!)]
        
        self.note = existingPhrase.note!
        
        self.type = existingPhrase.type!
        
        if let existingTags = existingPhrase.tags!.allObjects as? [Tag] {
            
            self.tags = existingTags.map({ (tag: Tag) -> String in return tag.name! }) as [String]
            
        } else {
            
            self.tags = [String]()
            
        }
        
    }
    
}