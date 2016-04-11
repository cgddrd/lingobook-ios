//
//  PhrasesViewControllerSearch.swift
//  LingoBook
//
//  Student No: 110024253
//

import Foundation
import UIKit

// This file is based on code available at: https://www.raywenderlich.com/113772/uisearchcontroller-tutorial

// We are using multiple 'extension' declarations to indicate how we can additional functionlity to an exisiting Swift class without modifiying the original source file.
// N.B: The 'extension' protocol follows much of the Decorator design pattern.

extension PhrasesViewController: UISearchDisplayDelegate {
    
    // Filter the collection of phrases using text search.
    func filterContentForSearchText(searchText: String, scope: Int = 0) {
        
        // If we have no phrases to search, bail out.
        if self.phrases == nil {
            self.phrasesSearchResults = nil
            return
        }
        
        // Here we are filtering the collection of phrases using a custom filtering closure (Trailing closure)
        self.phrasesSearchResults = self.phrases!.filter { aPhrase in
            
            switch (scope) {
            case (0):
                return aPhrase.textValue!.lowercaseString.containsString(searchText.lowercaseString)
            case (1):
                
                // Here, we are searching the array of translated phrases for one that has a 'textValue' property set to a given search term.
                
                // The part in curly brackets ('{') represents a PREDICATE (Trailing closure), and '$0' represents the current object within the collection that we are looking at as part of the search.
                return (aPhrase.translations?.contains { $0.textValue!!.lowercaseString.containsString(searchText.lowercaseString)})!
            case (2):
                return (aPhrase.tags?.contains {$0.name.lowercaseString.containsString(searchText.lowercaseString)})!
            default:
                phrasesSearchResults = nil
                return false
            }
            
        }
        
        // If everything goes very wrong, simply update the UITableView and move along.
        tableView.reloadData()
        
    }
    
    
}

// This delegate performs a search everytime the user makes a change to the search term inside the search box.
extension PhrasesViewController: UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!, scope: searchController.searchBar.selectedScopeButtonIndex)
    }
    
}


// This delegate makes sure that we conduct a search everytime the user changes the current scope (by tapping on a different scope button).
extension PhrasesViewController: UISearchBarDelegate {
    
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: selectedScope)
    }
    
}