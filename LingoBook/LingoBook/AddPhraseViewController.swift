//
//  AddPhraseViewController.swift
//  LingoBook
//
//  Created by Connor Goddard on 21/03/2016.
//  Copyright © 2016 Connor Goddard. All rights reserved.
//

import UIKit
import CoreData

class AddPhraseViewController: UITableViewController, UITableViewCellUpdateDelegate {
    
    var phraseTags = [String]()
    var phraseOriginalText = String()
    var phraseTranslatedtext = String()
    var phraseNote = String()
    
    var managedContext : NSManagedObjectContext! = nil;
    
    var dataController = DataController.sharedInstance;
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        super.setEditing(true, animated: true)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func displayErrorMessage(messageString: String) {
        
        let alert = UIAlertController(title: "Error", message: messageString, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func donePressed(sender: AnyObject) {
        
        print(phraseOriginalText)
        print(phraseTranslatedtext)
        print(phraseNote)
        
        dataController.addNewPhrase(phraseOriginalText, translatedPhraseText: phraseTranslatedtext, phraseTags: phraseTags, phraseNote: phraseNote)
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        SweetAlert().showAlert("Good job!", subTitle: "You clicked the button!", style: AlertStyle.Success)
        
    }
    
    @IBAction func cancelPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            
        case 0:
            return "Translation"
        case 1:
            return "Tags"
        case 2:
            return "Notes"
        default:
            return ""
            
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if (indexPath.section == 2) {
            
            return 120;
            
        } else {
            
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
            
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            
        case 0:
            return 2
        case 1:
            return phraseTags.count + 1
        case 2:
            return 1
        default:
            assert(false, "section \(section)")
            return 0
            
        }
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        switch section {
            
        case 0:
            return "Enter the translation for the new phrase."
        case 1:
            return "Enter any tags associated with the new phrase. (Optional)"
        case 2:
            return "Enter a note associated with the new phrase. (Optional)"
        default:
            return ""
            
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cellIdentifier = indexPath.row == 0 ? "static1" : "static2"
            
            if let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? AddPhraseTextTableViewCell {
                
                cell.delegate = self
                
                return cell
                
            }
            
            
        } else if indexPath.section == 1 {
            
            if let cell = tableView.dequeueReusableCellWithIdentifier("dynamic") as? AddPhraseTagTableViewCell {
                
                if indexPath.row < phraseTags.count {
                    
                    cell.textTag.text = phraseTags[indexPath.row]
                    
                }
                
                return cell
                
            }
            
        } else if indexPath.section == 2 {
            
            //return tableView.dequeueReusableCellWithIdentifier("static3")!
            
            if let cell = tableView.dequeueReusableCellWithIdentifier("static3") as? AddPhraseNoteTableViewCell {
                
                cell.delegate = self
                
                return cell
                
            }
        }
        
        return tableView.dequeueReusableCellWithIdentifier("static1")!;
        
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        
        if indexPath.section == 1 {
            
            if indexPath.row >= phraseTags.count {
                
                return .Insert
                
            } else {
                
                return .Delete
                
            }
            
        }
        
        return .None
        
    }
    
    override func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return indexPath.section == 1
        
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 1 {
            
            if editingStyle == UITableViewCellEditingStyle.Insert {
                
                let currentCell = tableView.cellForRowAtIndexPath(indexPath) as! AddPhraseTagTableViewCell;
                
                if let text = currentCell.textTag.text where text.isEmpty {
                    
                    displayErrorMessage("Please enter a tag to continue.")
                    
                } else {
                    
                    phraseTags.append(currentCell.textTag.text!)
                    
                    self.tableView.beginUpdates()
                    self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                    self.tableView.endUpdates()
                    
                    // Force the "new" input cell to be blank in order to display the placeholder text.
                    let currentCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: phraseTags.count, inSection: 1)) as! AddPhraseTagTableViewCell
                    currentCell.textTag.text = ""
                    
                }
                
            } else if editingStyle == UITableViewCellEditingStyle.Delete {
                
                phraseTags.removeAtIndex(indexPath.row)
                
                self.tableView.beginUpdates()
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                self.tableView.endUpdates()
                
            }
        }
        
    }
    
    func cellDidChangeValue(senderCell: UITableViewCell) {
        
        guard let indexPath = self.tableView.indexPathForCell(senderCell) else {
            return
        }
        
        if indexPath.section == 0 {
            
            if let currentCell = senderCell as? AddPhraseTextTableViewCell {
                
                switch indexPath.row {
                case 0:
                    self.phraseOriginalText = currentCell.textPhrase.text!
                    break
                case 1:
                    self.phraseTranslatedtext = currentCell.textPhrase.text!
                    break
                    
                default:
                    break
                }
                
            }
            
        } else if indexPath.section == 2 {
            
            if let currentCell = senderCell as? AddPhraseNoteTableViewCell {
                
                self.phraseNote = currentCell.textPhraseNote.text
                
            }
            
        }
        
    }
    
//    func addNewPhrase() {
//        
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        
//        managedContext = appDelegate.coreDataStack.managedObjectContext
//        
//        let newOriginPhraseEntity = NSEntityDescription.entityForName("OriginPhrase", inManagedObjectContext: managedContext)
//        let newTranslatedPhraseEntity = NSEntityDescription.entityForName("TranslatedPhrase", inManagedObjectContext: managedContext)
//        
//        //let newPhraseFetch = NSFetchRequest(entityName: "OriginPhrase")
//        
//        let newOriginPhrase = OriginPhrase(entity: newOriginPhraseEntity!, insertIntoManagedObjectContext: managedContext)
//        let newTranslatedPhrase = TranslatedPhrase(entity: newTranslatedPhraseEntity!, insertIntoManagedObjectContext: managedContext)
//        
//        newOriginPhrase.textValue = self.phraseOriginalText
//        newOriginPhrase.note = self.phraseNote
//        
//        newTranslatedPhrase.textValue = self.phraseTranslatedtext
//        
//        let translations = newOriginPhrase.translations!.mutableCopy() as! NSMutableSet
//        translations.addObject(newTranslatedPhrase)
//        newOriginPhrase.translations = translations as NSSet
//        
//        for newTagName in phraseTags {
//            
//            let trimmedTagName = newTagName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
//            
//            var currentTag = dataController.getExistingTag(trimmedTagName)
//            
//            if (currentTag == nil) {
//                
//                print("Creating new tag: \(trimmedTagName)")
//                
//                currentTag = Tag(entity: NSEntityDescription.entityForName("Tag", inManagedObjectContext: managedContext)!, insertIntoManagedObjectContext: managedContext)
//                currentTag?.name = trimmedTagName
//                
//            }
//            
//            let mutableOriginWords = currentTag!.originWords?.mutableCopy() as! NSMutableSet
//            mutableOriginWords.addObject(newOriginPhrase)
//            currentTag!.originWords = mutableOriginWords as NSSet
//            
//            
//            let mutableNewPhraseTags = newOriginPhrase.tags?.mutableCopy() as! NSMutableSet
//            mutableNewPhraseTags.addObject(currentTag!)
//            newOriginPhrase.tags = mutableNewPhraseTags as NSSet
//            
//        }
//        
//        do {
//            
//            try managedContext.save()
//            
//        } catch let error as NSError {
//            
//            print ("SOMETHING WENT WRONG: \(error)")
//            
//        }
//        
//    }
    
}
