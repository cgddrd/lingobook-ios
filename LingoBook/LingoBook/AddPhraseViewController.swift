//
//  AddPhraseViewController.swift
//  LingoBook
//
//  Created by Connor Goddard on 21/03/2016.
//  Copyright © 2016 Connor Goddard. All rights reserved.
//

import UIKit

class AddPhraseViewController: UIViewController {
    
    var count = 1;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //print(self.childViewControllers);
        
        //let test = self.childViewControllers.last as! UITableViewController
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    @IBAction func addNewPhrase(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "iOScreator", message:
            "dasdas", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func cancelView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 2
//    }
//    
//    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        switch section {
//            
//        case 0:
//            return "Word2"
//        case 1:
//            return "Tags"
//        default:
//            return "";
//            
//        }
//    }
    
//    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        
//        let title = self.tableView(tableView, titleForHeaderInSection: section)
//        
//        return (title == "") ? 0.0 : 20.0
//        
//    }
    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch section {
//        case 0:
//            return 2
//        case 1:
//            return count;
//        default:
//            assert(false, "section \(section)")
//            return 0
//        }
//    }
//    
//    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
//        
//        if indexPath.section == 1 {
//            return .Insert
//        }
//        
//        return .None
//        
//    }
//    
//    override func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        
//        if indexPath.section == 1 {
//            return true
//        }
//        
//        return false
//        
//    }
//    
//    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == UITableViewCellEditingStyle.Insert {
//            
//            count++;
//            
//            print(count)
//            //self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//            
//            self.tableView.beginUpdates()
//            self.tableView.insertRowsAtIndexPaths([
//                NSIndexPath(forRow: count, inSection: 1)
//                ], withRowAnimation: .Automatic)
//            self.tableView.endUpdates()
//            
//            
//        }
//    }


}
