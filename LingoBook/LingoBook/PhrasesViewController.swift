//
//  FirstViewController.swift
//  LingoBook
//
//  Created by Connor Goddard on 08/03/2016.
//  Copyright © 2016 Connor Goddard. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

class PhrasesViewController: UITableViewController, PhraseTableViewCellDelegate {
    
    var managedContext: NSManagedObjectContext! = nil;
    
    var phrases: [OriginPhrase]?
    
    var phrasesSearchResults: [OriginPhrase]?

    var phrasesDict: [String : OriginPhrase]?
    
    var revisionPhrases: [OriginPhrase]?
    
    var dataController = DataController.sharedInstance
    
    var networkController = NetworkController();
    
    var selectedCellIndexPath: NSIndexPath?
    
    var selectedCellHeight: CGFloat = 110.0

    // iOS 8 introduced 'UISearchController' to replace 'UISearchDisplayController'.
    // Unfortunatly, 'UISearchController' is currently not available via the Interface Builder (March 2016), so we have to define it manually.
    // See: https://www.raywenderlich.com/113772/uisearchcontroller-tutorial for more information.
    
    // Setting 'searchResultsController' to 'nil' tells Swift to use this controller to handle all search-related logic. (See: 'PhrasesViewControllerSearch.swift' for extension methods)
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        
        // Set up search controller - See: https://www.raywenderlich.com/113772/uisearchcontroller-tutorial for more information.
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        self.definesPresentationContext = true
        self.tableView.tableHeaderView = searchController.searchBar
        
        // Set up our scope buttons.
        searchController.searchBar.scopeButtonTitles = ["Original Phrase", "Translated Phrase", "Tag"]
        
        // Set a custom placeholder.
        searchController.searchBar.placeholder = "Search Phrasebook"
        
        searchController.searchBar.delegate = self
        
        // Load in the collection of saved phrases.
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        self.phrasesDict = appDel.revisionPhrases
        
    }
    
    @IBAction func refreshButtonPressed(sender: AnyObject) {
        
        self.getPhraseJSON()
      
    }
        
    func checkEmptyTable() {
        
        if (phrases != nil) && (phrases!.count > 0) {
            
            self.tableView.backgroundView = nil
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            
            selectedCellIndexPath = nil;
            
        } else {
            
            let emptyLabel = UILabel(frame: CGRectMake(50, 0, self.view.bounds.size.width - 50, self.view.bounds.size.height))
            
            let appFont = UIFont (name: "Bariol", size: 20)
            
            emptyLabel.lineBreakMode = .ByWordWrapping
            emptyLabel.numberOfLines = 0
            
            emptyLabel.font = appFont
            
            emptyLabel.text = "Hmm. Your phrasebook is currently empty. \n\n Why not add a new phrase?"
            
            emptyLabel.textAlignment = NSTextAlignment.Center
            
            self.tableView.backgroundView = emptyLabel
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        }
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if let retrievedPhrases = dataController.getPhrases() {
            phrases = retrievedPhrases
        }
        
        self.checkEmptyTable()
        
        tableView.reloadData()
        
        for cell in self.tableView.visibleCells {
            let test = cell as! PhraseTableViewCell
            test.setSelectedState(false, animated: false)
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        
        if self.editing {
            
            performSegueWithIdentifier("EditPhraseSegue", sender: tableView.cellForRowAtIndexPath(indexPath))
            
        }
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.active && searchController.searchBar.text != "" && phrasesSearchResults != nil {
            
            return phrasesSearchResults!.count
            
        } else if phrases != nil {
            
            return phrases!.count
            
        }
        
        return 0
        
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        // If we are in editing mode, we want to force all rows back to the standard height (to only display the origin phrase).
        if (selectedCellIndexPath != nil) && (selectedCellIndexPath == indexPath) && (!self.tableView.editing) && (!self.editing) {
            
            return selectedCellHeight;
            
        }
        
        return 44.0;
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if selectedCellIndexPath != nil && selectedCellIndexPath == indexPath {
            
            selectedCellIndexPath = nil
            
        } else {
            
            if selectedCellIndexPath != nil && selectedCellIndexPath != indexPath {
                
                let selectedCell = tableView.cellForRowAtIndexPath(selectedCellIndexPath!) as! PhraseTableViewCell
                
                selectedCell.setSelectedState(false, animated: true)
                
            }
            
            selectedCellIndexPath = indexPath
            
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
        if selectedCellIndexPath != nil {
            
            let selectedCell = tableView.cellForRowAtIndexPath(selectedCellIndexPath!) as! PhraseTableViewCell
            
            selectedCell.setSelectedState(true, animated: true)
            
            // This ensures, that the cell is fully visible once expanded
            tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .None, animated: true)
            
        }
        
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        if selectedCellIndexPath != nil && selectedCellIndexPath == indexPath {
            return nil;
        }
        
        return indexPath
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Make sure to use 'self.tableView' rather than just 'tableView' in order to fix 'expected nil' error on Search bar component.
        // Have no idea why this is the case, but it seems to work.
        // See: http://stackoverflow.com/a/31999606/4768230 for more information.
        let cell = self.tableView.dequeueReusableCellWithIdentifier("phraseCell", forIndexPath: indexPath) as! PhraseTableViewCell
        cell.delegate = self
        cell.indexPath = indexPath
        
        var originPhrase: OriginPhrase? = nil
        
        if searchController.active && searchController.searchBar.text != "" && phrasesSearchResults != nil {
            
            originPhrase = phrasesSearchResults![indexPath.row]
            
        } else if phrases != nil {
                
            originPhrase = phrases![indexPath.row]
            
        }
        
        if originPhrase != nil {
            
            cell.labelOriginPhrase.text = originPhrase!.textValue;
            
            if let retrievedTranslations = originPhrase!.translations?.allObjects as? [TranslatedPhrase] {
                
                if (retrievedTranslations.first != nil) {
                    
                    cell.labelTranslatedPhrase.text = retrievedTranslations.first?.textValue
                    
                }
                
            }
            
            if phrasesDict?.indexForKey(originPhrase!.textValue!) != nil {
                
                cell.setRevisionButtonStyle(true)
                
            } else {
                
                cell.setRevisionButtonStyle(false)
                
            }
            
        }
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .Destructive, title: "Delete") { (action, indexPath) in
            
            self.dataController.deletePhrase(self.phrases![indexPath.row])
            
            self.phrases?.removeAtIndex(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
        }
        
        delete.backgroundColor = UIColor.flatWatermelonColor()
        
        return [delete]
    }
    
    func getPhraseJSON() {
       
        //let url = "http://users.aber.ac.uk/clg11/sem2220/lingobook.json";
        
        let url = "http://localhost:8888/sem2220/lingobook.json"
        
        print("Downloading JSON")
        
        networkController.performFileDownload(url) { (data, response, error) in
            
            if let downloadedData = data {
                
                //let json = JSON(data: downloadedData)
                
                dispatch_async(dispatch_get_main_queue()) {
                    //print("Data is: \(json)")
                    print("Processing JSON on main thread")
                    
                    self.dataController.processJSON(downloadedData)
                    
                    //self.tableView.reloadData()
                    
                    self.phrases = self.dataController.getPhrases()
                    
                    self.checkEmptyTable()
                    
                    self.tableView.reloadData()
                    self.tableView.beginUpdates()
                    self.tableView.endUpdates()
                }
                
            } else {
                print("downloaded data was empty \(error?.localizedDescription)")
            }
        }
        
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if (self.tableView.editing) {
            return UITableViewCellEditingStyle.Delete
        }
        return UITableViewCellEditingStyle.None
    }
    
    // We need to override the normal editing method for the ViewController so we can force a UITableview refresh.
    override func setEditing(editing: Bool, animated: Bool) {
        
        super.setEditing(editing, animated: animated)
        
        
        if editing {
            
            for cell in self.tableView.visibleCells {
                let test = cell as! PhraseTableViewCell
                test.setEditState(true)
            }
            
            self.tableView.setEditing(editing, animated: animated)
            
        } else {
            
            for cell in self.tableView.visibleCells {
                let test = cell as! PhraseTableViewCell
                test.setEditState(false)
                
            }
            
            if selectedCellIndexPath != nil {

                let selectedCell = tableView.cellForRowAtIndexPath(selectedCellIndexPath!) as! PhraseTableViewCell
                
                selectedCell.setSelectedState(true, animated: true)
                
            }
            
            
            self.tableView.setEditing(editing, animated: animated)
            
        }
        
        
        
        // Make sure to refresh the UITableView so that all of the row heights reset back to normal.
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "EditPhraseSegue" {
            
            let editPhraseNavigationController = segue.destinationViewController as! UINavigationController
            
            // Get the ViewController from the top of the navigation stack (will always be 'EditPhraseViewController' - only one view).
            let editPhraseViewController = editPhraseNavigationController.topViewController as! EditPhraseViewController
            
            if let selectedPhraseCell = sender as? PhraseTableViewCell {
                
                let indexPath = self.tableView.indexPathForCell(selectedPhraseCell)
                
                let selectedPhrase = phrases![indexPath!.row] as OriginPhrase
                
                editPhraseViewController.currentPhrase = PhraseModel(existingPhrase: selectedPhrase)
                
            }
            
        }
        
    }
    
    func addRevisionButtonPressed(sender: PhraseTableViewCell, indexPath: NSIndexPath) {
        
        if phrasesDict != nil && phrases != nil {
            
            if phrases?.count > indexPath.row {
                
                let selectedPhrase = phrases![indexPath.row]
                
                // If we find an entry for the phrase inside the dictionary of revision indexes, we want to remove it.
                
                if let revisionPhraseDictIndex = phrasesDict?.indexForKey(selectedPhrase.textValue!) {
                    
                    phrasesDict!.removeAtIndex(revisionPhraseDictIndex)
                    sender.setRevisionButtonStyle(false)
                    
                } else {
                    
                    phrasesDict![selectedPhrase.textValue!] = selectedPhrase
            
                    sender.setRevisionButtonStyle(true)
                    
                }
                
            }
            
            // Update changes to shared collection of phrases.
            let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
            appDel.revisionPhrases = self.phrasesDict!
            
        }
        
    }

}

extension UIView {
    // Name this function in a way that makes sense to you...
    // slideFromLeft, slideRight, slideLeftToRight, etc. are great alternative names
    func slideInFromLeft(duration: NSTimeInterval = 0.5, completionDelegate: AnyObject? = nil) {
        // Create a CATransition animation
        let slideInFromLeftTransition = CATransition()
        
        // Set its callback delegate to the completionDelegate that was provided (if any)
        if let delegate: AnyObject = completionDelegate {
            slideInFromLeftTransition.delegate = delegate
        }
        
        // Customize the animation's properties
        slideInFromLeftTransition.type = kCATransitionPush
        slideInFromLeftTransition.subtype = kCATransitionFromLeft
        slideInFromLeftTransition.duration = duration
        slideInFromLeftTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        slideInFromLeftTransition.fillMode = kCAFillModeRemoved
        
        // Add the animation to the View's layer
        self.layer.addAnimation(slideInFromLeftTransition, forKey: "slideInFromLeftTransition")
    }
    
    func slideInFromRight(duration: NSTimeInterval = 0.5, completionDelegate: AnyObject? = nil) {
        // Create a CATransition animation
        let slideInFromRightTransition = CATransition()
        
        // Set its callback delegate to the completionDelegate that was provided (if any)
        if let delegate: AnyObject = completionDelegate {
            slideInFromRightTransition.delegate = delegate
        }
        
        // Customize the animation's properties
        slideInFromRightTransition.type = kCATransitionPush
        slideInFromRightTransition.subtype = kCATransitionFromRight
        slideInFromRightTransition.duration = duration
        slideInFromRightTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        slideInFromRightTransition.fillMode = kCAFillModeBoth
        
        // Add the animation to the View's layer
        self.layer.addAnimation(slideInFromRightTransition, forKey: "slideInFromRightTransition")
    }
    
    func slideInFromTop(duration: NSTimeInterval = 0.5, completionDelegate: AnyObject? = nil) {
        // Create a CATransition animation
        let slideInFromRightTransition = CATransition()
        
        // Set its callback delegate to the completionDelegate that was provided (if any)
        if let delegate: AnyObject = completionDelegate {
            slideInFromRightTransition.delegate = delegate
        }
        
        // Customize the animation's properties
        slideInFromRightTransition.type = kCATransitionPush
        slideInFromRightTransition.subtype = kCATransitionFromTop
        slideInFromRightTransition.duration = duration
        slideInFromRightTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        slideInFromRightTransition.fillMode = kCAFillModeBoth
        
        // Add the animation to the View's layer
        self.layer.addAnimation(slideInFromRightTransition, forKey: "slideInFromTopTransition")
    }
    
    func slideInFromBottom(duration: NSTimeInterval = 0.5, completionDelegate: AnyObject? = nil) {
        // Create a CATransition animation
        let slideInFromRightTransition = CATransition()
        
        // Set its callback delegate to the completionDelegate that was provided (if any)
        if let delegate: AnyObject = completionDelegate {
            slideInFromRightTransition.delegate = delegate
        }
        
        // Customize the animation's properties
        slideInFromRightTransition.type = kCATransitionPush
        slideInFromRightTransition.subtype = kCATransitionFromBottom
        slideInFromRightTransition.duration = duration
        slideInFromRightTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        slideInFromRightTransition.fillMode = kCAFillModeBoth
        
        // Add the animation to the View's layer
        self.layer.addAnimation(slideInFromRightTransition, forKey: "slideInFromBottomTransition")
    }
}
