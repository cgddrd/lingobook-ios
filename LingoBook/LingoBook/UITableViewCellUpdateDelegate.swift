//
//  UITableViewInputCellUpdateDelegate.swift
//  LingoBook
//
//  Student No: 110024253
//

import UIKit


// Delegate for detecting changes in UITableViewCell input content.
// Code modified from original source: http://stackoverflow.com/a/32748935/4768230

protocol UITableViewInputCellUpdateDelegate {
    func cellDidChangeValue(senderCell: UITableViewCell)
}
