//
//  EditPhraseViewController.swift
//  LingoBook
//
//  Created by Connor Goddard on 01/04/2016.
//  Copyright © 2016 Connor Goddard. All rights reserved.
//

import UIKit
import CoreData

class EditPhraseViewController: UITableViewController, UITableViewCellUpdateDelegate {
    
    var managedContext : NSManagedObjectContext! = nil
    
    var dataController = DataController.sharedInstance
    
    var currentPhrase: PhraseModel?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        super.setEditing(true, animated: true)
        
    }
    
    func displayErrorMessage(messageString: String) {
        
        let alert = UIAlertController(title: "Error", message: messageString, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func donePressed(sender: AnyObject) {
        
        dataController.createOrUpdatePhrase(currentPhrase!)
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
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
            return currentPhrase!.tags.count + 1
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
            return "Enter the translation for the phrase."
        case 1:
            return "Enter any tags associated with the phrase. (Optional)"
        case 2:
            return "Enter a note associated with the new phrase. (Optional)"
        default:
            return ""
            
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cellIdentifier = (indexPath.row == 0) ? "static1" : "static2"
            
            if let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? AddPhraseTextTableViewCell {
                
                cell.textPhrase.text = (indexPath.row == 0) ? currentPhrase?.originPhraseText : currentPhrase?.translatedPhrases.first?.translatedText

                cell.delegate = self
                
                return cell
                
            }
            
            
        } else if indexPath.section == 1 {
            
            if let cell = tableView.dequeueReusableCellWithIdentifier("dynamic") as? AddPhraseTagTableViewCell {
                
                if let currentTags = currentPhrase?.tags {
                    
                    if indexPath.row < currentTags.count {
                        
                        cell.textTag.text = currentTags[indexPath.row]
                        
                    }
                    
                }
            
                return cell
                
            }
            
        } else if indexPath.section == 2 {
            
            if let cell = tableView.dequeueReusableCellWithIdentifier("static3") as? AddPhraseNoteTableViewCell {
                
                cell.textPhraseNote.text = currentPhrase!.note
                
                cell.delegate = self
                
                return cell
                
            }
        }
        
        return tableView.dequeueReusableCellWithIdentifier("static1")!;
        
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        
        if indexPath.section == 1 {
            
            if indexPath.row >= currentPhrase?.tags.count {
                
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
                    
                    currentPhrase!.tags.append(currentCell.textTag.text!)
                    
                    self.tableView.beginUpdates()
                    self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                    self.tableView.endUpdates()
                    
                    // Force the "new" input cell to be blank in order to display the placeholder text.
                    let currentCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: currentPhrase!.tags.count, inSection: 1)) as! AddPhraseTagTableViewCell
                    currentCell.textTag.text = ""
                    
                }
                
            } else if editingStyle == UITableViewCellEditingStyle.Delete {
                
                currentPhrase?.tags.removeAtIndex(indexPath.row)
                
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
                    currentPhrase?.originPhraseText = currentCell.textPhrase.text!
                    break
                case 1:
                    currentPhrase?.translatedPhrases = [TranslationModel(translatedText: currentCell.textPhrase.text!, locale: "cy")]
                    break
                    
                default:
                    break
                }
                
            }
            
        } else if indexPath.section == 2 {
            
            if let currentCell = senderCell as? AddPhraseNoteTableViewCell {
                
                currentPhrase?.note = currentCell.textPhraseNote.text
                
            }
            
        }
        
    }
    
}

