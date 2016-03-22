//
//  AddPhraseViewController.swift
//  LingoBook
//
//  Created by Connor Goddard on 21/03/2016.
//  Copyright © 2016 Connor Goddard. All rights reserved.
//

import UIKit

class AddPhraseViewController: UITableViewController {
    
    var count = 0;
    
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
        return 2
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            
        case 0:
            return "Words"
        case 1:
            return "Tags"
        default:
            return "";
            
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            
        case 0:
            return 2
        case 1:
            return count + 1;
        default:
            assert(false, "section \(section)")
            return 0
            
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("dynamic");
        
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
                
                cell = tableView.dequeueReusableCellWithIdentifier("static1")
                
            } else if (indexPath.row == 1) {
                
                cell = tableView.dequeueReusableCellWithIdentifier("static2")
            }
        
            
        } else if (indexPath.section == 1) {
            
            cell = tableView.dequeueReusableCellWithIdentifier("dynamic")
            
            if(indexPath.row >= count){
                
                //cell!.textLabel!.text = "Add Row";
                
            } else {
                
                //cell!.textLabel!.text = "Dynamic";
                
            }
            
        }
        
        return cell!

    }

    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        
        if (indexPath.section == 1) {
            
            if(indexPath.row >= count) {
                
                return .Insert;
                
            } else {
                
                return .Delete;
                
            }
            
        }
        
        return .None
        
    }
    
    override func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
//        if indexPath.section == 1 {
//            return true
//        }
//        
//        return false
        
        return indexPath.section == 1
        
    }
   
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (indexPath.section == 1) {
            
            if editingStyle == UITableViewCellEditingStyle.Insert {
                
                let currentCell = tableView.cellForRowAtIndexPath(indexPath) as! AddTagTableViewCell;
                
                if let text = currentCell.textTag.text where text.isEmpty
                {
                    //do something if it's empty
                    print("bollocks!")
                }
                
                count++;
                
                print(count)
                
                self.tableView.beginUpdates()
                self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: count, inSection: 1)], withRowAnimation: .Automatic)
                self.tableView.endUpdates()
                
                
            } else if editingStyle == UITableViewCellEditingStyle.Delete {
                
                count--;
                
                self.tableView.beginUpdates()
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                self.tableView.endUpdates()
                
            }
            
        }
        

    }


}
