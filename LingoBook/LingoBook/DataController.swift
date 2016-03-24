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

class DataController {
    
    static let sharedInstance = DataController()
    private init() {} //This prevents others from using the default '()' initializer for this class.
    
    // ManagedObjectContext from AppDelegate
    lazy var moc: NSManagedObjectContext = {
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDel.coreDataStack.managedObjectContext
    }()
    
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
    
    func addNewPhrase(originPhraseText: String, translatedPhraseText: String, phraseTags: [String], phraseNote: String) {
        
        let newOriginPhraseEntity = NSEntityDescription.entityForName("OriginPhrase", inManagedObjectContext: moc)
        let newTranslatedPhraseEntity = NSEntityDescription.entityForName("TranslatedPhrase", inManagedObjectContext: moc)
        
        let newOriginPhrase = OriginPhrase(entity: newOriginPhraseEntity!, insertIntoManagedObjectContext: moc)
        let newTranslatedPhrase = TranslatedPhrase(entity: newTranslatedPhraseEntity!, insertIntoManagedObjectContext: moc)
        
        newOriginPhrase.textValue = originPhraseText
        newOriginPhrase.note = phraseNote
        
        newTranslatedPhrase.textValue = translatedPhraseText
        
        let translations = newOriginPhrase.translations!.mutableCopy() as! NSMutableSet
        translations.addObject(newTranslatedPhrase)
        newOriginPhrase.translations = translations as NSSet
        
        for newTagName in phraseTags {
            
            let trimmedTagName = newTagName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            
            let currentTag = findOrCreateTag(trimmedTagName)

            let mutableOriginWords = currentTag.originWords?.mutableCopy() as! NSMutableSet
            mutableOriginWords.addObject(newOriginPhrase)
            currentTag.originWords = mutableOriginWords as NSSet
            
            let mutableNewPhraseTags = newOriginPhrase.tags?.mutableCopy() as! NSMutableSet
            mutableNewPhraseTags.addObject(currentTag)
            newOriginPhrase.tags = mutableNewPhraseTags as NSSet
            
        }
        
        do {
            
            try moc.save()
            
        } catch let error as NSError {
            
            print ("SOMETHING WENT WRONG: \(error)")
            
        }
        
    }
    
}
