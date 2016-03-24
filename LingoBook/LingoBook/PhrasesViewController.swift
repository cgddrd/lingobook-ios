//
//  FirstViewController.swift
//  LingoBook
//
//  Created by Connor Goddard on 08/03/2016.
//  Copyright © 2016 Connor Goddard. All rights reserved.
//

import UIKit
import CoreData

class PhrasesViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var managedContext: NSManagedObjectContext! = nil;
    
    var phrases = [OriginPhrase]()
    
    //let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var dataController = DataController.sharedInstance

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
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("phraseCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = phrases[indexPath.row].textValue;
        
        if let retrievedTranslations = phrases[indexPath.row].translations?.allObjects as? [TranslatedPhrase] {
            
            if (retrievedTranslations.first != nil) {
                
                cell.detailTextLabel?.text = retrievedTranslations.first?.textValue
                
            }
            
        }
        
        return cell
        
    }

    func updateSearchResultsForSearchController(searchController: UISearchController) {

    }
    
    
//    func getPhrases() -> [OriginPhrase]? {
//        
//        managedContext = appDelegate.managedObjectContext
//        
//        do {
//            
//            let phraseFetch = NSFetchRequest(entityName: "OriginPhrase")
//            
//            if let retrievedPhrases = try managedContext.executeFetchRequest(phraseFetch) as? [OriginPhrase] {
//                
//                return retrievedPhrases
//                
//            }
//            
//            
//        } catch let error as NSError {
//            NSLog("Error whilst returning OriginPhrases from Core Data: \(error)")
//        }
//        
//        return nil
//        
//    }

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

