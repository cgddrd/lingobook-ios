//
//  PhraseInputViewController.swift
//  LingoBook
//
//  Student No: 110024253
//

import UIKit
import CoreData

// Represents the UITableViewController acting as the input form for adding or editing a phrase.
class PhraseInputViewController: UITableViewController, UITableViewInputCellUpdateDelegate {
    
    var managedContext : NSManagedObjectContext! = nil
    
    // Get a reference to the DataController.
    var dataController = DataController()
    
    var phraseDetails: PhraseModel?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Immediately force the UITableView into edit mode, so that tags may be added and removed.
        super.setEditing(true, animated: true)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // If we are EDITING a phrase, 'phraseDetails' SHOULD NOT be set to 'nil'.
        if (phraseDetails == nil) {
            
            // If we reach this point, we are ADDING a new phrase.
            phraseDetails = PhraseModel()
        }
    }
    
    @IBAction func donePressed(sender: AnyObject) {
        
        // Check that neither the origin phrase text or translated phrase text is empty.
        if (self.phraseDetails!.originPhraseText.isEmpty || self.phraseDetails!.translatedPhrases.count <= 0) {
            
            let alertView = UIAlertController(title: "Error", message: "Please ensure text is entered for the origin and translated phrase texts.", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            presentViewController(alertView, animated: true, completion: nil)
        
        } else {
            
            // Pass the changes through to the data contoller for processing.
            dataController.createOrUpdatePhrase(phraseDetails!)
        
            // Remove the view from screen.
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }
        
    }
    
    @IBAction func cancelPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func displayErrorMessage(messageString: String) {
        
        let alert = UIAlertController(title: "Error", message: messageString, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
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
        
        // For the 'Notes' section, the cell is to be set to a greater height that the rest.
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

            if (phraseDetails != nil) {
                // We return the current number of tags + 1 to accomodate the 'Add Tag' cell.
                return phraseDetails!.tags.count + 1
            }
            
            return 1
            
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
        
        // For the origin text and translated text inputs (static cells).
        if indexPath.section == 0 {
            
            let cellIdentifier = indexPath.row == 0 ? "cellPhraseOrigin_Static" : "cellPhraseTranslation_Static"
            
            if let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? TextFieldInputTableViewCell {
                
                // Set text field content based on the row number.
                cell.textPhrase.text = (indexPath.row == 0) ? phraseDetails?.originPhraseText : phraseDetails?.translatedPhrases.first?.translatedText
                
                cell.delegate = self
                
                return cell
                
            }
        
        // For the phrase type (static cell).
        } else if indexPath.section == 1 {
            
            if let cell = tableView.dequeueReusableCellWithIdentifier("cellPhraseType_Static") as? TextFieldInputTableViewCell {
                
                cell.textPhrase.text = phraseDetails?.type
                
                cell.delegate = self
                
                return cell
                
            }
         
        // For the phrase tags (dynamic cell).
        } else if indexPath.section == 2 {
            
            if let cell = tableView.dequeueReusableCellWithIdentifier("cellPhraseTag_Dynamic") as? AddPhraseTagTableViewCell {
                
                if indexPath.row < phraseDetails!.tags.count {
                    
                    cell.textTag.text = phraseDetails!.tags[indexPath.row]
                    
                }
                
                return cell
                
            }
        
        // For the phrase note (static cell)
        } else if indexPath.section == 3 {
            
            if let cell = tableView.dequeueReusableCellWithIdentifier("cellPhraseNote_Static") as? TextViewInputTableViewCell {
                
                cell.textPhraseNote.text = phraseDetails?.note
                
                cell.delegate = self
                
                return cell
                
            }
        }
        
        return tableView.dequeueReusableCellWithIdentifier("cellPhraseOrigin_Static")!;
        
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        
        // Restrict the editing style to only cells in the 'Tags' section.
        if indexPath.section == 2 {
            
            if indexPath.row >= phraseDetails?.tags.count {
                
                return .Insert
                
            } else {
                
                return .Delete
                
            }
            
        }
        
        return .None
        
    }
    
    override func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        // Only allow indenting of cells whilst in edit mode to cells in the 'Tags' section.
        return indexPath.section == 2
        
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        // We only want to manage edit changes made in the 'Tags' section.
        if indexPath.section == 2 {
            
            if editingStyle == UITableViewCellEditingStyle.Insert {
                
                let currentCell = tableView.cellForRowAtIndexPath(indexPath) as! AddPhraseTagTableViewCell;
                
                // Perform some validation checking.
                if let text = currentCell.textTag.text where text.isEmpty {
                    
                    displayErrorMessage("Please enter a tag to continue.")
                    
                } else {
                    
                    // Add the new tag to the model collection.
                    phraseDetails!.tags.append(currentCell.textTag.text!)
                    
                    // Refresh the table view to reflect the new addition in the number of rows.
                    self.tableView.beginUpdates()
                    self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                    self.tableView.endUpdates()
                    
                    // Force the "new" input cell to be blank in order to display the placeholder text.
                    let currentCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: phraseDetails!.tags.count, inSection: indexPath.section)) as! AddPhraseTagTableViewCell
                    currentCell.textTag.text = ""
                    
                }
            
            } else if editingStyle == UITableViewCellEditingStyle.Delete {
                
                // Remove the current tag.
                phraseDetails?.tags.removeAtIndex(indexPath.row)
                
                // Refresh the table view to reflect the new addition in the number of rows.
                self.tableView.beginUpdates()
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                self.tableView.endUpdates()
                
            }
        }
        
    }
    
    // UITableViewInputCellUpdateDelegate function for handling changes to UITextField and UITextView values.
    
    func cellDidChangeValue(senderCell: UITableViewCell) {
        
        // If we have no index path (e.g. if cell isn't on the screen), then abort.
        guard let indexPath = self.tableView.indexPathForCell(senderCell) else {
            return
        }
        
        // For the origin text and translated text inputs (static cell).
        if indexPath.section == 0 {
            
            if let currentCell = senderCell as? TextFieldInputTableViewCell {
                
                
                switch indexPath.row {
                
                    
                // For origin text input.
                case 0:
                    
                    phraseDetails!.originPhraseText = currentCell.textPhrase.text!
                    break
                
                // For translated text input.
                case 1:
                    
                    // At some point we could change this to add multiple phrases.
                    phraseDetails!.translatedPhrases = [TranslationModel(translatedText: currentCell.textPhrase.text!, locale: "cy")]
                    break
                    
                default:
                    break
                }
                
            }
        
            
        // For phrase type input (static cell).
        } else if indexPath.section == 1 {
            
            if let currentCell = senderCell as? TextFieldInputTableViewCell {
                
                phraseDetails!.type = currentCell.textPhrase.text!
                
            }
        
        // For the phrase note input (static cell).
        } else if indexPath.section == 3 {
            
            if let currentCell = senderCell as? TextViewInputTableViewCell {
                
                phraseDetails!.note = currentCell.textPhraseNote.text
                
            }
            
        }
        
    }
    
}

