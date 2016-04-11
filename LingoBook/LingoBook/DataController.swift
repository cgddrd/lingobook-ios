//
//  DataController.swift
//  LingoBook
//
//  Student No: 110024253
//

import Foundation
import CoreData
import UIKit
import SwiftyJSON

// Responsible for all data management and persistent tasks related to Core Data and NSUserDefaults.
class DataController {

    // Obtain a reference to the shared SINGLETON instance of the Core Data stack.
    lazy var coreDataStack = CoreDataStackController.sharedInstance
    
    // ManagedObjectContext from CoreDataStackControler
    lazy var moc: NSManagedObjectContext = {
        return self.coreDataStack.managedObjectContext
    }()
    
    // ManagedObjectContext from CoreDataStackControler
    lazy var psc: NSPersistentStoreCoordinator = {
        return self.coreDataStack.persistentStoreCoordinator
    }()
    
    // Save the managed object context to disk via CoreDataStackController.
    private func saveManagedContext() -> NSError? {
        
        do {
            
            try moc.save()
            
        } catch let error as NSError {
            
            return error
            
        }
        
        return nil
        
    }
    
    // Retrieves an OriginPhrase entity via the unique object ID, or nil if a match isn't found.
    func getPhraseByIdUrl(url: NSURL) -> OriginPhrase? {
        
        if let objectId = psc.managedObjectIDForURIRepresentation(url) {
            
            if let data = moc.objectWithID(objectId) as? OriginPhrase {
                
                return data
                
            }
            
        }
        
        return nil
        
    }
    
    // Returns all OriginPhrase entities currently stored within the Core Data object graph, or nil if an error occures.
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
    
    // Returns a Tag entity identified by a given tag name, or nil if no matching tag is found.
    func findExistingTag(tagName: String) -> Tag? {
        
        do {
            
            let tagFetch = NSFetchRequest(entityName: "Tag")
            
            // '[c]' tells the predicate to use case-insensitive equality comparison.
            tagFetch.predicate = NSPredicate(format: "name LIKE[c] %@", tagName)
            
            if let retrievedTags = try moc.executeFetchRequest(tagFetch) as? [Tag] {
                
                // Really, we should only ever find a single instance of a given tag name.
                if (retrievedTags.count > 0) {
                    
                    return retrievedTags.first
                    
                }
                
            }
            
            
        } catch let error as NSError {
            NSLog("Error whilst retrieving Tags: \(error)")
        }
        
        return nil
        
    }
    
    // Returns an OriginPhrase entity identified by a given phrase text, or nil if no matching phrase is found.
    func findExistingPhrase(phraseOriginText: String) -> OriginPhrase? {
        
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
    
    // Returns an TranslatedPhrase entity identified by a given translated phrase text, or nil if no matching translation is found.
    func findExistingTranslation(phraseTranslatedText: String, locale: String) -> TranslatedPhrase? {
        
        do {
            
            let originPhraseFetch = NSFetchRequest(entityName: "TranslatedPhrase")
            
            // Note here that we use both the text value AND the locale of the phrase in order to locate a unique instance of a translation.
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
    
    // Returns either an existing instance of a Tag entity identified by a given tag name, or creates a new instance.
    func findOrCreateTag(tagName: String) -> Tag {
        
        var currentTag : Tag
        
        if let existingTag = findExistingTag(tagName) {
            
            print("Found existing tag: \(tagName)")
            
            currentTag = existingTag
            
        } else {
            
            print("Creating new tag: \(tagName)")
            
            let tagEntity = NSEntityDescription.entityForName("Tag", inManagedObjectContext: moc)
            
            currentTag = Tag(entity: tagEntity!, insertIntoManagedObjectContext: moc)
            
            currentTag.name = tagName
            
        }
        
        return currentTag
        
    }
    
    // Returns either an existing instance of an OriginPhrase entity identified by a given phrase text, or creates a new instance.
    func findOrCreatePhrase(phraseOriginText: String) -> OriginPhrase {
        
        var phrase: OriginPhrase
        
        if let existingPhrase = findExistingPhrase(phraseOriginText) {
            
            phrase = existingPhrase
            
        } else {
            
            print("Creating new phrase: \(phraseOriginText)")
            
            phrase = createNewPhrase()
        }
        
        return phrase
        
    }
    
    // Returns either an existing instance of an TranslatedPhrase entity identified by a given translation text, or creates a new instance.
    func findOrCreateTranslation(phraseTranslatedText: String, locale: String) -> TranslatedPhrase {
        
        var phrase: TranslatedPhrase
        
        if let existingPhrase = findExistingTranslation(phraseTranslatedText, locale: locale) {
            
            phrase = existingPhrase
            
        } else {
            
            print("Creating new translated phrase: \(phraseTranslatedText)")
            
            phrase = createNewTranslatedPhrase()
        }
        
        return phrase
        
    }
    
    // Either updates an existing instance of a phrase entity (including OriginPhrase, TranslatedPhrase and Tag CD entities), or creates a new instance using the specified values.
    func createOrUpdatePhrase(phraseData: PhraseModel) -> OriginPhrase? {
        
        // Find or create a new OriginPhrase instance.
        let phrase = findOrCreatePhrase(phraseData.originPhraseText) as OriginPhrase
        
        phrase.textValue = phraseData.originPhraseText
        phrase.note = phraseData.note
        phrase.type = phraseData.type
        
        // Process the specified phrase tags.
        for newTagName in phraseData.tags {
            
            let trimmedTagName = newTagName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            
            // Use an existing instance of Tag, or create a new one.
            let currentTag = findOrCreateTag(trimmedTagName)
            
            // Create a new relationship between the Tag and OriginPhrase entities.
            currentTag.addPhrase(phrase)
            phrase.addTag(currentTag)
            
        }
        
        // Process the new translations.
        for newTranslation in phraseData.translatedPhrases {
            
            // Use an existing instance of TranslatedPhrase, or create a new one.
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
    
    // Initialises and returns a new OriginPhrase entity using the shared ManagedObjectContent.
    private func createNewPhrase() -> OriginPhrase {
        
        let newOriginPhraseEntity = NSEntityDescription.entityForName("OriginPhrase", inManagedObjectContext: moc)
        
        let newOriginPhrase = OriginPhrase(entity: newOriginPhraseEntity!, insertIntoManagedObjectContext: moc)
        
        return newOriginPhrase
        
    }
    
    // Initialises and returns a new TranslatedPhrase entity using the shared ManagedObjectContent.
    private func createNewTranslatedPhrase() -> TranslatedPhrase {
        
        let newTranslatedPhraseEntity = NSEntityDescription.entityForName("TranslatedPhrase", inManagedObjectContext: moc)
        
        let newTranslatedPhrase = TranslatedPhrase(entity: newTranslatedPhraseEntity!, insertIntoManagedObjectContext: moc)
        
        return newTranslatedPhrase
        
    }
    
    // Deletes an existing OriginPhrase entity from the Core Data object graph.
    // Note: The associated TranslatedPhrase entity is automatically deleted via the 'Cascade' deletion rule in effect.
    func deleteExisitingPhrase(phraseToDelete: OriginPhrase) {
        
        moc.deleteObject(phraseToDelete)
        
        self.saveManagedContext()
        
    }
    
    // Convenience function for processing JSON data stored within an NSData object.
    func processJSON(data: NSData) {
        
        let jsonData = JSON(data: data)
        
        self.processJSON(jsonData)
        
    }
    
    // Processes a collection of phrases represented via JSON notation.
    // JSON access and manipulation provided by the SwiftJSON library: https://github.com/SwiftyJSON/SwiftyJSON
    func processJSON(json: JSON?) {
        
        if (json != nil) {
            
            // Access the array of phrases in the JSON object.
            let phraseCollection = json!["phrases"]
            
            // Iterate through each phrase data object, and process accordingly.
            for (_, subJson):(String, JSON) in phraseCollection {
                
                // Attempt to access the underlying object representation for the current phrase.
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
                    
                    // Process the new PhraseModel instance in the same way as if a phrase was created manually.
                    self.createOrUpdatePhrase(newPhrase)
                    
                } else {
                    
                    print("Error: Cannot convert JSON data into Dictionary for processing. Aborting.")
                    
                }

            }
            
        } else {
            
            print("Error: JSON data value set to 'nil'. No data to process. Aborting.")
            
        }
        
    }
    
    // Returns a dictionary of saved revision phrases from NSUserDefaults, or nil if no collection is found.
    func loadSavedRevisionPhrases() -> [String : OriginPhrase]? {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let data = defaults.valueForKey("SavedPhrases") as? NSData {
            
            if let savedPhrases = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [String : NSURL] {
                
                var loadedPhrases = [String : OriginPhrase]()
                
                // Iterate through each of the phrase object IDs retrieved from NSUserDefaults, and locate the corresponding ObjectPhrase entity from Core Data.
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
    
    // Persist a dictionary of revision phrase object IDs to NSUserDefaults to retrieve again at a later point in time.
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