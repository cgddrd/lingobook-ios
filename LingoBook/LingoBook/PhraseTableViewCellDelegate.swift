//
//  PhraseTableViewCellDelegate.swift
//  LingoBook
//
//  Student No: 110024253
//

import Foundation

// Delegate for detecting tap events on the 'Add Revision' button, contained within a PhraseTableViewCell.
protocol PhraseTableViewCellDelegate {
    
    func addRevisionButtonPressed(sender: PhraseTableViewCell, indexPath: NSIndexPath);
    
}