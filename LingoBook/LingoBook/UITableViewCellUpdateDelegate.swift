//
//  UITableViewCellUpdateDelegate.swift
//  LingoBook
//
//  Created by Connor Goddard on 23/03/2016.
//  Copyright © 2016 Connor Goddard. All rights reserved.
//

import UIKit


// Code modified from original source: http://stackoverflow.com/a/32748935/4768230

protocol UITableViewCellUpdateDelegate {
    func cellDidChangeValue(senderCell: UITableViewCell)
}
