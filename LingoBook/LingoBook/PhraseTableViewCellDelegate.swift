//
//  PhraseTableViewCellDelegate.swift
//  LingoBook
//
//  Created by Connor Goddard on 03/04/2016.
//  Copyright © 2016 Connor Goddard. All rights reserved.
//

import Foundation

protocol PhraseTableViewCellDelegate {
    
    func addRevisionButtonPressed(sender: PhraseTableViewCell, indexPath: NSIndexPath);
    
}