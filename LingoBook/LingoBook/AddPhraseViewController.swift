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
    
    var phraseDetails = PhraseModel()
    
    var managedContext : NSManagedObjectContext! = nil;
    
    var dataController = DataController();
    
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
        
        // var errorMessage : String? = nil;
        
        dataController.createOrUpdatePhrase(phraseDetails)
        
//        if let newPhrase = dataController.addNewPhrase(phraseOriginalText, phraseTags: phraseTags, phraseNote: phraseNote) {
//            
//            // For now, we only allow a single translation in Welsh, but 'DataController.swift' has pre-exisiting support to add more translations in future.
//            let newPhraseTranslation = dataController.addPhraseTranslation(newPhrase, translationText: self.phraseTranslatedtext, translationLocale: "cy")
//            
//            if newPhraseTranslation == nil {
//                errorMessage = "An error has occured whilst adding a new translation to the phrase. Please try again later."
//            }
//            
//        } else {
//                
//            errorMessage = "An error has occured whilst adding a new phrase. Please try again later."
//            
//        }
//        
//        if (errorMessage != nil) {
//            
//            let alertView = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .Alert)
//            alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
//            presentViewController(alertView, animated: true, completion: nil)
//            
//        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        //SweetAlert().showAlert("Good job!", subTitle: "You clicked the button!", style: AlertStyle.Success)
        
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
        return 4
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            
        case 0:
            return "Translation"
        case 1:
            return "Type"
        case 2:
            return "Tags"
        case 3:
            return "Notes"
        default:
            return ""
            
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if (indexPath.section == 3) {
            
            return 120;
            
        } else {
            
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
            
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            
        case 0:
            return 2
        case 1, 3:
            return 1
        case 2:
            return phraseDetails.tags.count + 1
        default:
            return 0
            
        }
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        switch section {
            
        case 0:
            return "Enter the translation for the new phrase."
        case 1:
            return "Enter the type of phrase (e.g. 'noun' or 'adjective') (Optional)"
        case 2:
            return "Enter any tags associated with the new phrase. (Optional)"
        case 3:
            return "Enter a note associated with the new phrase. (Optional)"
        default:
            return ""
            
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cellIdentifier = indexPath.row == 0 ? "cellPhraseOrigin_Static" : "cellPhraseTranslation_Static"
            
            if let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? TextFieldInputTableViewCell {
                
                cell.delegate = self
                
                return cell
                
            }
        
        } else if indexPath.section == 1 {
            
            if let cell = tableView.dequeueReusableCellWithIdentifier("cellPhraseType_Static") as? TextFieldInputTableViewCell {
                
                cell.delegate = self
                
                return cell
                
            }
            
        } else if indexPath.section == 2 {
            
            if let cell = tableView.dequeueReusableCellWithIdentifier("cellPhraseTag_Dynamic") as? AddPhraseTagTableViewCell {
                
                if indexPath.row < phraseDetails.tags.count {
                    
                    cell.textTag.text = phraseDetails.tags[indexPath.row]
                    
                }
                
                return cell
                
            }
            
        } else if indexPath.section == 3 {
            
            if let cell = tableView.dequeueReusableCellWithIdentifier("cellPhraseNote_Static") as? TextViewInputTableViewCell {
                
                cell.delegate = self
                
                return cell
                
            }
        }
        
        
        return UITableViewCell()
        
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        
        if indexPath.section == 2 {
            
            if indexPath.row >= phraseDetails.tags.count {
                
                return .Insert
                
            } else {
                
                return .Delete
                
            }
            
        }
        
        return .None
        
    }
    
    override func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return indexPath.section == 2
        
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 2 {
            
            if editingStyle == UITableViewCellEditingStyle.Insert {
                
                let currentCell = tableView.cellForRowAtIndexPath(indexPath) as! AddPhraseTagTableViewCell;
                
                if let text = currentCell.textTag.text where text.isEmpty {
                    
                    displayErrorMessage("Please enter a tag to continue.")
                    
                } else {
                    
                    phraseDetails.tags.append(currentCell.textTag.text!)
                    
                    self.tableView.beginUpdates()
                    self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                    self.tableView.endUpdates()
                    
                    // Force the "new" input cell to be blank in order to display the placeholder text.
                    let currentCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: phraseDetails.tags.count, inSection: indexPath.section)) as! AddPhraseTagTableViewCell
                    currentCell.textTag.text = ""
                    
                }
                
            } else if editingStyle == UITableViewCellEditingStyle.Delete {
                
                phraseDetails.tags.removeAtIndex(indexPath.row)
                
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
            
            if let currentCell = senderCell as? TextFieldInputTableViewCell {
                
                switch indexPath.row {
                case 0:
                    
                    phraseDetails.originPhraseText = currentCell.textPhrase.text!
                    break
                    
                case 1:
                    
                    // At some point we could change this to add multiple phrases.
                    phraseDetails.translatedPhrases = [TranslationModel(translatedText: currentCell.textPhrase.text!, locale: "cy")]
                    break
                    
                default:
                    break
                }
                
            }
            
        } else if indexPath.section == 1 {
            
            if let currentCell = senderCell as? TextFieldInputTableViewCell {
                
                phraseDetails.type = currentCell.textPhrase.text!
                
            }
            
        } else if indexPath.section == 3 {
            
            if let currentCell = senderCell as? TextViewInputTableViewCell {
                
                phraseDetails.note = currentCell.textPhraseNote.text
                
            }
            
        }
        
    }
    
}
