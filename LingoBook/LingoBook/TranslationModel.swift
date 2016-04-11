//
//  TranslationModel.swift
//  LingoBook
//
//  Student No: 110024253
//

import Foundation

// Model struct providing temporary representation for a translation entity whilst working outside of Core Data.
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