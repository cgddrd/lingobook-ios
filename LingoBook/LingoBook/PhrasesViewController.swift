//
//  PhrasesViewController.swift
//  LingoBook
//
//  Student No: 110024253
//

import UIKit
import CoreData
import SwiftyJSON

// The main UITableViewController representing the language phrasebook.
class PhrasesViewController: UITableViewController, PhraseTableViewCellDelegate {
    
    var managedContext: NSManagedObjectContext! = nil;
    
    // The complete list of phrases loaded in from Core Data.
    var phrases: [OriginPhrase]?
    
    // Holds the list of search results.
    var phrasesSearchResults: [OriginPhrase]?

    // Holds the temporary collection of phrases selected for revision (persisted to NSUserDefaults)
    var revisionPhrases: [String : OriginPhrase]?
    
    var dataController = DataController()
    
    var networkController = NetworkController();
    
    // The index path of the current selected cell.
    var selectedCellIndexPath: NSIndexPath?
    
    // The custom height of the selected cell.
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
        
        // Setup the handler for the UIRefreshControl.
        // Modified from original source: https://www.andrewcbancroft.com/2015/03/17/basics-of-pull-to-refresh-for-swift-developers/
        self.refreshControl?.addTarget(self, action: "handleRefresh:", forControlEvents: .ValueChanged)
        
        // Load in the collection of saved phrases.
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        self.revisionPhrases = appDel.revisionPhrases
        
    }
    
    // Handler fired upon trigger of UIRefreshControl.
    // Modified from original source: https://www.andrewcbancroft.com/2015/03/17/basics-of-pull-to-refresh-for-swift-developers/
    func handleRefresh(refreshControl: UIRefreshControl) {
        
        let url = "http://users.aber.ac.uk/clg11/sem2220/lingobook.json";
        
        // Initiate file download.
        networkController.performFileDownload(url) { (data, response, error) in
            
            // Closure called after response recieved from server.
            
            // Move from background thread back into main thread.
            dispatch_async(dispatch_get_main_queue()) {
                
                // Check that we have some data recieved.
                if let downloadedData = data {

                    print("Processing JSON on main thread")
                    
                    // Initiate processing of JSON contents.
                    self.dataController.processJSON(downloadedData)
                    
                    // Update list of phrases recieved from Core Data to reflect any changes.
                    self.phrases = self.dataController.getPhrases()
                    
                    // Check data source is not empty, and if so, display placeholder message.
                    self.checkEmptyTable()
                    
                    self.tableView.reloadData()
                    
                    // Reset all cells in UITableView to become unselected.
                    self.disableSelectedStateOnVisibleCells()
                    
                    
                } else {

                    let alertView = UIAlertController(title: "Download Error", message: "An error occured whilst downloading phrases. Please check your network connection.", preferredStyle: .Alert)
                    alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    self.presentViewController(alertView, animated: true, completion: nil)
                }
                
            }
        }
        
        // Hide the UIRefreshControl one finished.
        refreshControl.endRefreshing()
        
    }
    
    // Checks if the data source is empty, and if so displays a placeholder message instead of an empty UITableView.
    func checkEmptyTable() {
        
        if (self.phrases != nil) && (self.phrases!.count > 0) {
            
            // Remove any existing placeholder message, and re-activate the cell lines.
            self.tableView.backgroundView = nil
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            
            selectedCellIndexPath = nil;
            
        } else {
            
            // Set up the new label that will act as the placeholde message.
            let emptyLabel = UILabel(frame: CGRectMake(50, 0, self.view.bounds.size.width - 50, self.view.bounds.size.height))
            
            let appFont = UIFont (name: "Bariol", size: 20)
            
            emptyLabel.lineBreakMode = .ByWordWrapping
            emptyLabel.numberOfLines = 0
            
            emptyLabel.font = appFont
            
            emptyLabel.text = "Hmm. Your phrasebook is currently empty. \n\n Why not add a new phrase?"
            
            emptyLabel.textAlignment = NSTextAlignment.Center
            
            // Set the background view of the UITableView to the new message, and hide the cell lines.
            self.tableView.backgroundView = emptyLabel
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        }
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // Update the complete list of phrases from Core Data (provides the data source for the UITableView)
        if let retrievedPhrases = dataController.getPhrases() {
            phrases = retrievedPhrases
        }
        
        self.checkEmptyTable()
    
        tableView.reloadData()
        
        // Reset all cells in UITableView to become unselected.
        disableSelectedStateOnVisibleCells()
        
    }
    
    // Iterates through all visible cells, setting their selected state to 'false'.
    func disableSelectedStateOnVisibleCells() {
        
        for cell in self.tableView.visibleCells {
            let currentCell = cell as! PhraseTableViewCell
            currentCell.setSelectedState(false, animated: false)
        }
        
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // UITableViewDelegate function for handling a 'tap' action on a cell accessory.
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        
        // We only ever want to perform some kind of action whilst in edit mode.
        if self.editing {
            
            // Display the 'Edit Phrase' view for the current cell.
            performSegueWithIdentifier("EditPhraseSegue", sender: tableView.cellForRowAtIndexPath(indexPath))
            
        }
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // If we are performing a search, then set the number of rows to be the number of search results.
        if searchController.active && searchController.searchBar.text != "" && phrasesSearchResults != nil {
            
            return phrasesSearchResults!.count
        
        // Otherwise, display all phrase entries.
        } else if phrases != nil {
            
            return phrases!.count
            
        }
        
        return 0
        
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        // For the currently selected cell, we want to use a custom height to show it in an expanded state.
        // N.B.If we are in editing mode, we want to force all rows back to the standard height (to only display the origin phrase).
        if (selectedCellIndexPath != nil) && (selectedCellIndexPath == indexPath) && (!self.tableView.editing) && (!self.editing) {
            
            return selectedCellHeight;
            
        }
        
        return 44.0
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // If the current index path matches the exisiting selected index path, set this to 'nil' so that we don't try and expand the cell again for no reason.
        if selectedCellIndexPath != nil && selectedCellIndexPath == indexPath {
            
            selectedCellIndexPath = nil
            
        } else {
            
            // Force the cell at the existing selected index path to be collapsed.
            if selectedCellIndexPath != nil && selectedCellIndexPath != indexPath {
                
                let selectedCell = tableView.cellForRowAtIndexPath(selectedCellIndexPath!) as! PhraseTableViewCell
                
                selectedCell.setSelectedState(false, animated: true)
                
            }
            
            // Update the selected index path to the current cell index path.
            selectedCellIndexPath = indexPath
            
        }
        
        // If we're not dealing with the same selected cell, expand this cell to reveal more contents.
        if selectedCellIndexPath != nil {
            
            let selectedCell = tableView.cellForRowAtIndexPath(selectedCellIndexPath!) as! PhraseTableViewCell
            
            selectedCell.setSelectedState(true, animated: true)
            
            // This ensures that the cell is fully visible once expanded.
            tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .None, animated: true)
            
        }
        
        // Refresh the table to reflect the changes.
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    
//    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
//        
//        if selectedCellIndexPath != nil && selectedCellIndexPath == indexPath {
//            return nil;
//        }
//        
//        return indexPath
//        
//    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Make sure to use 'self.tableView' rather than just 'tableView' in order to fix 'expected nil' error on Search bar component.
        // Have no idea why this is the case, but it seems to work.
        // See: http://stackoverflow.com/a/31999606/4768230 for more information.
        let cell = self.tableView.dequeueReusableCellWithIdentifier("phraseCell", forIndexPath: indexPath) as! PhraseTableViewCell
        cell.delegate = self
        cell.indexPath = indexPath
        
        var originPhrase: OriginPhrase? = nil
        
        // Set up the contents for each cell, using data obtained from the data source.
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
            
            if originPhrase?.note != nil && originPhrase?.note?.isEmpty == false {
                
                cell.labelTags.text = originPhrase?.note
                
            } else if let phraseTags = originPhrase?.tags?.allObjects as? [Tag] {
                
                let tagNames = phraseTags.map({(tag: Tag) -> String in return tag.name!}) as [String]
                
                cell.labelTags.text  = tagNames.joinWithSeparator(", ")
                
            } else {
                
                cell.labelTags.text = ""
                
            }
            
            // Set the selected state for the Add Revision button based on whether the current phrase exists in the collection of revision phrases.
            if revisionPhrases?.indexForKey(originPhrase!.textValue!) != nil {
                
                cell.setRevisionButtonStyle(true)
                
            } else {
                
                cell.setRevisionButtonStyle(false)
                
            }
            
            
            if !self.editing {
                cell.btnAddRevision.hidden = false
            }
            
        }
        
        return cell
        
    }
    
    // UITableViewDelegate function for overriding the setup of edit action buttons for a given cell.
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        // Declare a new action button to delete a phrase,
        let delete = UITableViewRowAction(style: .Destructive, title: "Delete") { (action, indexPath) in
            
            let phrase = self.phrases![indexPath.row]
            
            // Remove from saved revision phrases (if required).
            if let revisionPhrase = self.revisionPhrases?.indexForKey(phrase.textValue!) {
                
                self.revisionPhrases?.removeAtIndex(revisionPhrase)
                
                // Update changes to shared collection of phrases.
                let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
                appDel.revisionPhrases = self.revisionPhrases!
                
            }
            
            // Delete the phrase from Core Data.
            self.dataController.deletePhrase(self.phrases![indexPath.row])
            
            // Remove the phrase from the UITableView data source.
            self.phrases?.removeAtIndex(indexPath.row)
            
            // Remove the cell representing the deleted phrase from the UITableView.
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
        }
        
        // Set a custom background color for the new Delete button.
        delete.backgroundColor = UIColor.flatWatermelonColor()
        
        return [delete]
    }
    
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        
        // Only allow the delete accessory to be made visible whilst in edit mode.
        
        if (self.tableView.editing) {
            
            return UITableViewCellEditingStyle.Delete
            
        }
        
        return UITableViewCellEditingStyle.None
    }
    
    
    // We need to override the normal editing method for the ViewController so we can force a UITableview refresh, and set the edit state for PhraseTableViewCells.
    override func setEditing(editing: Bool, animated: Bool) {
        
        super.setEditing(editing, animated: animated)
        
        if editing {
            
            // Instruct all cells to enter the edit state (hide additional content and collapse)
            for cell in self.tableView.visibleCells {
                let currentCell = cell as! PhraseTableViewCell
                currentCell.setEditState(true)
            }
            
            self.tableView.setEditing(editing, animated: animated)
            
        } else {
            
            // Instruct all cells to enter the edit state (restore Add Revision button)
            for cell in self.tableView.visibleCells {
                let currentCell = cell as! PhraseTableViewCell
                currentCell.setEditState(false)
            }
            
            // Re-expand the currently-selected cell if set.
            if selectedCellIndexPath != nil {

                let selectedCell = tableView.cellForRowAtIndexPath(selectedCellIndexPath!) as! PhraseTableViewCell
                
                selectedCell.setSelectedState(true, animated: true)
                
            }
            
            // Finally, go ahead with the normal UITableView edit mode.
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
            let editPhraseViewController = editPhraseNavigationController.topViewController as! PhraseInputViewController
            
            // Pass in the details for the current phrase that we wish to edit.
            if let selectedPhraseCell = sender as? PhraseTableViewCell {
                
                let indexPath = self.tableView.indexPathForCell(selectedPhraseCell)
                
                let selectedPhrase = phrases![indexPath!.row] as OriginPhrase
                
                editPhraseViewController.phraseDetails = PhraseModel(existingPhrase: selectedPhrase)
                
            }
            
        }
        
    }
    
    // PhraseTableViewCellDelegate function for handling a 'tap' action on the Add Revision button.
    func addRevisionButtonPressed(sender: PhraseTableViewCell, indexPath: NSIndexPath) {
        
        if revisionPhrases != nil && phrases != nil {
            
            if phrases?.count > indexPath.row {
                
                let selectedPhrase = phrases![indexPath.row]
                
                // If we find an entry for the phrase inside the dictionary of revision indexes, we want to remove it.
                if let revisionPhraseDictIndex = revisionPhrases?.indexForKey(selectedPhrase.textValue!) {
                    
                    revisionPhrases!.removeAtIndex(revisionPhraseDictIndex)
                    sender.setRevisionButtonStyle(false)
                
                // Otherwise, we want to add the phrase to the collection of revision phrases.
                } else {
                    
                    revisionPhrases![selectedPhrase.textValue!] = selectedPhrase
                    sender.setRevisionButtonStyle(true)
                    
                }
                
            }
            
            // Update changes to central collection of revision phrases.
            let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
            appDel.revisionPhrases = self.revisionPhrases!
            
        }
        
    }

}