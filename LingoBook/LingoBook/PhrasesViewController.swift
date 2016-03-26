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

class PhrasesViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var managedContext: NSManagedObjectContext! = nil;
    
    var phrases = [OriginPhrase]()
    
    var dataController = DataController.sharedInstance
    
    var networkController = NetworkController();
    
    var selectedCellIndexPath: NSIndexPath?
    
    let selectedCellHeight: CGFloat = 110.0

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
//        searchController.searchResultsUpdater = self
//        searchController.dimsBackgroundDuringPresentation = false
//        definesPresentationContext = true
//        tableView.tableHeaderView = searchController.searchBar
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if let retrievedPhrases = dataController.getPhrases() {
            phrases = retrievedPhrases
        }
        
        if phrases.count == 0 {
            
            let emptyLabel = UILabel(frame: CGRectMake(50, 0, self.view.bounds.size.width - 50, self.view.bounds.size.height))
            
            let appFont = UIFont (name: "Bariol", size: 20)
            
            emptyLabel.lineBreakMode = .ByWordWrapping
            emptyLabel.numberOfLines = 0
            
            emptyLabel.font = appFont
            
            emptyLabel.text = "Hmm. Your phrasebook is currently empty. \n\n Why not add a new one?"
            
            emptyLabel.textAlignment = NSTextAlignment.Center
            
            self.tableView.backgroundView = emptyLabel
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            
        } else {
            
            self.tableView.backgroundView = nil
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            
            selectedCellIndexPath = nil;
            
        }
        
        tableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return phrases.count
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if selectedCellIndexPath != nil && selectedCellIndexPath == indexPath {
            
            return selectedCellHeight;
            
        }
        
        return 44.0;
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if selectedCellIndexPath != nil && selectedCellIndexPath == indexPath {
            
            selectedCellIndexPath = nil
            
        } else {
            
            selectedCellIndexPath = indexPath
            
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
        if selectedCellIndexPath != nil {
            
            let selectedCell = tableView.cellForRowAtIndexPath(indexPath) as! PhraseTableViewCell
            
            let selectedColour = UIColor(red: 243.0/255.0, green: 243.0/255.0, blue: 243.0/255.0, alpha: 1.0);
            
            selectedCell.contentView.backgroundColor = selectedColour
            
            UIView.animateWithDuration(0.2, animations: {
                selectedCell.imageArrow.transform = CGAffineTransformMakeRotation((90.0 * CGFloat(M_PI)) / 180.0)
            })

            
            // This ensures, that the cell is fully visible once expanded
            tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .None, animated: true)
            
        }
        
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        if selectedCellIndexPath != nil {
            
            let cellToDeSelect = tableView.cellForRowAtIndexPath(indexPath) as! PhraseTableViewCell
            cellToDeSelect.contentView.backgroundColor = UIColor.clearColor()
            
            UIView.animateWithDuration(0.2, animations: {
                cellToDeSelect.imageArrow.transform = CGAffineTransformMakeRotation((0.0 * CGFloat(M_PI)) / 180.0)
            })
            
        }
        
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        if selectedCellIndexPath != nil && selectedCellIndexPath == indexPath {
            return nil;
        }
        
        return indexPath
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("phraseCell", forIndexPath: indexPath) as! PhraseTableViewCell
        
        cell.labelOriginPhrase.text = phrases[indexPath.row].textValue;
        
        if let retrievedTranslations = phrases[indexPath.row].translations?.allObjects as? [TranslatedPhrase] {
            
            if (retrievedTranslations.first != nil) {
                
                cell.labelTranslatedPhrase.text = retrievedTranslations.first?.textValue
                
            }
            
        }
        
        if selectedCellIndexPath != nil && selectedCellIndexPath == indexPath {
            
            let selectedColour = UIColor(red: 243.0/255.0, green: 243.0/255.0, blue: 243.0/255.0, alpha: 1.0);
            
            cell.contentView.backgroundColor = selectedColour
        }
        
        return cell
        
    }
    
    @IBAction func getPhraseJSON() {
        
        let url = "http://users.aber.ac.uk/clg11/sem2220/lingobook.json";
        
        networkController.performFileDownload(url) { (data, response, error) in
            
            if let downloadedData = data {
                
                //let json = JSON(data: downloadedData)
                
               // dispatch_async(dispatch_get_main_queue()) {
                    //print("Data is: \(json)")
                    print("Processing JSON on main thread")
                    self.dataController.processJSON(downloadedData)
               // }
                
            } else {
                print("downloaded data was empty \(error?.localizedDescription)")
            }
        }
        
    }

    func updateSearchResultsForSearchController(searchController: UISearchController) {

    }

}

//extension PhrasesViewController: UISearchBarDelegate {
//    // MARK: - UISearchBar Delegate
//    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
//        //filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
//    }
//}
//
//extension PhrasesViewController: UISearchResultsUpdating {
//    // MARK: - UISearchResultsUpdating Delegate
//    func updateSearchResultsForSearchController(searchController: UISearchController) {
//        let searchBar = searchController.searchBar
//        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
//        //filterContentForSearchText(searchController.searchBar.text!, scope: scope)
//    }
//}

