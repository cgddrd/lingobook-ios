//
//  DataController.swift
//  LingoBook
//
//  Created by Connor Goddard on 23/03/2016.
//  Copyright © 2016 Connor Goddard. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import SwiftyJSON

class DataController {
    
    // By having a STATIC variable for the shared instance, we are guaranteeing that the Singleton is THREAD-SAFE.
    // This is because under-the-hood, 'static let' calls 'dispatch_once', which guarantees the GCD will only ever run this code ONCE AND ONLY ONCE!
    // See: http://stackoverflow.com/a/24147830/4768230 for more information.
    static let sharedInstance = DataController()
    
    //This prevents others from using the default '()' initializer for this class.
    private init() {}
    
    // ManagedObjectContext from AppDelegate
    lazy var moc: NSManagedObjectContext = {
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDel.coreDataStack.managedObjectContext
    }()
    
    // ManagedObjectContext from AppDelegate
    lazy var psc: NSPersistentStoreCoordinator = {
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDel.coreDataStack.persistentStoreCoordinator
    }()
    
    
    func getPhraseByIdUrl(url: NSURL) -> OriginPhrase? {
        
        if let objectId = psc.managedObjectIDForURIRepresentation(url) {
            
            if let data = moc.objectWithID(objectId) as? OriginPhrase {
                
                return data
                
            }
            
        }
        
        return nil
        
    }
    
    func getPhrases() -> [OriginPhrase]? {
        
        do {
            
            let phraseFetch = NSFetchRequest(entityName: "OriginPhrase")
            
            if let retrievedPhrases = try moc.executeFetchRequest(phraseFetch) as? [OriginPhrase] {
                
                return retrievedPhrases
                
            }
            
            
        } catch let error as NSError {
            NSLog("Error whilst returning OriginPhrases from Core Data: \(error)")
        }
        
        return nil
        
    }
    
    func getExistingTag(tagName: String) -> Tag? {
        
        do {
            
            let tagFetch = NSFetchRequest(entityName: "Tag")
            
            // '[c]' tells the predicate to use case-insensitive equality comparison.
            tagFetch.predicate = NSPredicate(format: "name LIKE[c] %@", tagName)
            
            if let retrievedTags = try moc.executeFetchRequest(tagFetch) as? [Tag] {
                
                if (retrievedTags.count > 0) {
                    
                    return retrievedTags.first
                    
                }
                
            }
            
            
        } catch let error as NSError {
            NSLog("Error whilst retrieving Tags: \(error)")
        }
        
        return nil
        
    }
    
    func getExistingPhrase(phraseOriginText: String) -> OriginPhrase? {
        
        do {
            
            let originPhraseFetch = NSFetchRequest(entityName: "OriginPhrase")
            
            // '[c]' tells the predicate to use case-insensitive equality comparison.
            originPhraseFetch.predicate = NSPredicate(format: "textValue LIKE[c] %@", phraseOriginText)
            
            if let retrievedPhrases = try moc.executeFetchRequest(originPhraseFetch) as? [OriginPhrase] {
                
                if (retrievedPhrases.count > 0) {
                    
                    return retrievedPhrases.first
                    
                }
                
            }
            
            
        } catch let error as NSError {
            NSLog("Error whilst retrieving OriginPhrases: \(error)")
        }
        
        return nil
    }
    
    func getExistingTranslation(phraseTranslatedText: String, locale: String) -> TranslatedPhrase? {
        
        do {
            
            let originPhraseFetch = NSFetchRequest(entityName: "TranslatedPhrase")
            
            // '[c]' tells the predicate to use case-insensitive equality comparison.
            originPhraseFetch.predicate = NSPredicate(format: "textValue LIKE[c] %@ AND locale LIKE[c] %@", phraseTranslatedText, locale)
            
            if let retrievedPhrases = try moc.executeFetchRequest(originPhraseFetch) as? [TranslatedPhrase] {
                
                if (retrievedPhrases.count > 0) {
                    
                    return retrievedPhrases.first
                    
                }
                
            }
            
            
        } catch let error as NSError {
            NSLog("Error whilst retrieving TranslatedPhrases: \(error)")
        }
        
        return nil
    }
    
    func findOrCreateTag(tagName: String) -> Tag {
        
        var currentTag : Tag
        
        if let existingTag = getExistingTag(tagName) {
            
            currentTag = existingTag
            
        } else {
            
            print("Creating new tag: \(tagName)")
            
            let tagEntity = NSEntityDescription.entityForName("Tag", inManagedObjectContext: moc)
            
            currentTag = Tag(entity: tagEntity!, insertIntoManagedObjectContext: moc)
            
            currentTag.name = tagName
            
        }
        
        return currentTag
        
    }
    
    private func saveManagedContext() -> NSError? {
        
        do {
    
            try moc.save()
            
        } catch let error as NSError {
            
            return error
            
        }
        
        return nil
        
    }
    
    
    func findOrCreatePhrase(phraseOriginText: String) -> OriginPhrase {
        
        var phrase: OriginPhrase
        
        if let existingPhrase = getExistingPhrase(phraseOriginText) {
            
            phrase = existingPhrase
            
        } else {
            
            print("Creating new phrase: \(phraseOriginText)")
            
            phrase = createNewPhrase()
        }
        
        return phrase
        
    }
    
    func findOrCreateTranslation(phraseTranslatedText: String, locale: String) -> TranslatedPhrase {
        
        var phrase: TranslatedPhrase
        
        if let existingPhrase = getExistingTranslation(phraseTranslatedText, locale: locale) {
            
            phrase = existingPhrase
            
        } else {
            
            print("Creating new translated phrase: \(phraseTranslatedText)")
            
            phrase = createNewTranslatedPhrase()
        }
        
        return phrase
        
    }
 
    func createOrUpdatePhrase(phraseData: PhraseModel) -> OriginPhrase? {
        
        let phrase = findOrCreatePhrase(phraseData.originPhraseText) as OriginPhrase
        
        phrase.textValue = phraseData.originPhraseText
        phrase.note = phraseData.note
        phrase.type = phraseData.type
        
        for newTagName in phraseData.tags {
            
            let trimmedTagName = newTagName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            
            let currentTag = findOrCreateTag(trimmedTagName)
            
            currentTag.addPhrase(phrase)
            phrase.addTag(currentTag)
            
        }
        
        for newTranslation in phraseData.translatedPhrases {
            
            
            let currentTranslation = findOrCreateTranslation(newTranslation.translatedText, locale: newTranslation.locale)
            
            currentTranslation.textValue = newTranslation.translatedText
            currentTranslation.locale = newTranslation.locale
            currentTranslation.origin = phrase
            
            phrase.addTranslation(currentTranslation)
            
        }
        
        if let error = self.saveManagedContext() {

            print("An error has occured whilst saving the new phrase: \(error.localizedDescription)")
            return nil
            
        }
        
        return phrase
        
    }
    
    private func createNewPhrase() -> OriginPhrase {
        
        let newOriginPhraseEntity = NSEntityDescription.entityForName("OriginPhrase", inManagedObjectContext: moc)
        
        let newOriginPhrase = OriginPhrase(entity: newOriginPhraseEntity!, insertIntoManagedObjectContext: moc)
        
        return newOriginPhrase
        
    }
    
    private func createNewTranslatedPhrase() -> TranslatedPhrase {
        
        let newTranslatedPhraseEntity = NSEntityDescription.entityForName("TranslatedPhrase", inManagedObjectContext: moc)
        
        let newTranslatedPhrase = TranslatedPhrase(entity: newTranslatedPhraseEntity!, insertIntoManagedObjectContext: moc)
        
        return newTranslatedPhrase
        
    }
    
    func deletePhrase(phraseToDelete: OriginPhrase) {
        
        moc.deleteObject(phraseToDelete)
        
        self.saveManagedContext()
        
    }
    
    func processJSON(data: NSData) {
        
        let jsonData = JSON(data: data)
        
        self.processJSON(jsonData)
        
    }
    
    func processJSON(json: JSON?) {
        
        if (json != nil) {
            
            let phraseCollection = json!["phrases"]
            
            for (_, subJson):(String, JSON) in phraseCollection {
                
                if let jsonPhraseData = subJson.dictionary {
                    
                    var newPhrase = PhraseModel()
                    
                    if let originPhraseText = jsonPhraseData["text"] {
                        
                        newPhrase.originPhraseText = originPhraseText.string!
                        
                    }
                    
                    if let phraseNote = jsonPhraseData["note"] {
                        
                        newPhrase.note = phraseNote.string!
                        
                    }
                    
                    if let phraseType = jsonPhraseData["type"] {
                        
                        newPhrase.type = phraseType.string!
                        
                    }
                    
                    if let phraseTranslations = jsonPhraseData["translations"] {
                        
                        for (_, translationJson):(String, JSON) in phraseTranslations {
                            
                            if let translationData = translationJson.dictionary {
                                
                                var newTranslation = TranslationModel()
                                
                                if let translatedPhraseText = translationData["text"] {
                                    
                                    newTranslation.translatedText = translatedPhraseText.string!
                                    
                                }
                                
                                if let translatedPhraseLocale = translationData["locale"] {
                                    
                                    newTranslation.locale = translatedPhraseLocale.string!
                                    
                                }
                                
                                newPhrase.translatedPhrases.append(newTranslation)
                                
                            }
                            
                        }
                        
                    } else {
                        
                        print("WARNING: No translations found for current phrase in JSON data.")
                        
                    }
                    
                    if let phraseTags = jsonPhraseData["tags"] {
                        
                        for tag in phraseTags.arrayValue {
                            
                            if !tag.stringValue.isEmpty {
                                
                                newPhrase.tags.append(tag.stringValue)
                                
                            }
                            
                        }
                        
                    }
                    
                    self.createOrUpdatePhrase(newPhrase)
                    
                } else {
                    
                    print("Error: Cannot convert JSON data into Dictionary for processing. Aborting.")
                    
                }

            }
            
        } else {
            
            print("Error: JSON data value set to 'nil'. No data to process. Aborting.")
            
        }
        
    }
    
    func loadSavedRevisionPhrases() -> [String : OriginPhrase]? {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let data = defaults.valueForKey("SavedPhrases") as? NSData {
            
            if let savedPhrases = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [String : NSURL] {
                
                var loadedPhrases = [String : OriginPhrase]()
                
                for (phraseKey, phraseURL) in savedPhrases {
                    
                    if let locatedPhrase = self.getPhraseByIdUrl(phraseURL) {
                        
                        loadedPhrases[phraseKey] = locatedPhrase
                        
                    }
                    
                }
                
                return loadedPhrases
                
            }
            
        }
        
        return nil
    }
    
    func saveRevisionPhrases(phrases : [String : OriginPhrase]) {
        
        var phraseDictUrls = [String : NSURL]()
    
        for (phraseKey, phrase) in phrases as [String : OriginPhrase] {
            
            phraseDictUrls[phraseKey] = phrase.objectID.URIRepresentation()
            
        }
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let data = NSKeyedArchiver.archivedDataWithRootObject(phraseDictUrls)
        defaults.setValue(data, forKey: "SavedPhrases")
        
    }

}