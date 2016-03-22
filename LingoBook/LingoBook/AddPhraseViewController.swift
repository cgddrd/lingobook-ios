//
//  AddPhraseViewController.swift
//  LingoBook
//
//  Created by Connor Goddard on 21/03/2016.
//  Copyright © 2016 Connor Goddard. All rights reserved.
//

import UIKit

class AddPhraseViewController: UITableViewController {
    
    var tags = [String]();
    
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
    
    @IBAction func cancelView(sender: AnyObject) {
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
            return "New Phrase"
        case 1:
            return "Translations"
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
            return 1
        case 1:
            return 1
        case 2:
            return tags.count + 1
        case 3:
            return 1
        default:
            assert(false, "section \(section)")
            return 0
            
        }
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        switch section {
            
        case 0:
            return "Enter the new phrase in English."
        case 1:
            return "Enter at least one translation for the new phrase."
        case 2:
            return "Enter any tags associated with the new phrase. (Optional)"
        case 3:
            return "Enter a note associated with the new phrase. (Optional)"
        default:
            return ""
            
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("dynamic")
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                
                cell = tableView.dequeueReusableCellWithIdentifier("static1")
            }
                
//            } else if indexPath.row == 1 {
//                
//                cell = tableView.dequeueReusableCellWithIdentifier("static2")
//            }
        
        } else if indexPath.section == 1 {
            
            
            cell = tableView.dequeueReusableCellWithIdentifier("dynamic2")
            
        
        } else if indexPath.section == 2 {
            
            if indexPath.row < tags.count {
                
                if let tagCell = cell as? AddTagTableViewCell {
                    
                    tagCell.textTag.text = tags[indexPath.row]
                    
                    return tagCell
                    
                }
                
            }
            
        } else if indexPath.section == 3 {
            
            cell = tableView.dequeueReusableCellWithIdentifier("static3")
        }
        
        return cell!

    }

    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        
        if indexPath.section == 1 {
            
            return .Insert
        
        } else if indexPath.section == 2 {
            
            if indexPath.row >= tags.count {
                
                return .Insert
                
            } else {
                
                return .Delete
                
            }
            
        }
        
        return .None
        
    }
    
    override func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return indexPath.section == 1 || indexPath.section == 2
        
    }
   
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 2 {
            
            if editingStyle == UITableViewCellEditingStyle.Insert {
                
                let currentCell = tableView.cellForRowAtIndexPath(indexPath) as! AddTagTableViewCell;
                
                if let text = currentCell.textTag.text where text.isEmpty
                {
                    displayErrorMessage("Please enter a tag to continue.")
                    
                } else {
                    
                    tags.append(currentCell.textTag.text!)
                    
                    self.tableView.beginUpdates()
                    self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                    self.tableView.endUpdates()
                    
                    let currentCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: tags.count, inSection: 1)) as! AddTagTableViewCell
                
                    currentCell.textTag.text = ""
                    
                }
                
            } else if editingStyle == UITableViewCellEditingStyle.Delete {
                
                tags.removeAtIndex(indexPath.row)
                
                self.tableView.beginUpdates()
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                self.tableView.endUpdates()
                
            }
            
        } else if indexPath.section == 1 {
            
            
            if editingStyle == UITableViewCellEditingStyle.Insert {
                
                performSegueWithIdentifier("testSegue", sender: nil)
            }
        }
        
    }


}
