//
//  AddPhraseTableViewCell.swift
//  LingoBook
//
//  Created by Connor Goddard on 23/03/2016.
//  Copyright © 2016 Connor Goddard. All rights reserved.
//

import UIKit

class AddPhraseTextTableViewCell: UITableViewCell {

    @IBOutlet weak var textPhrase: UITextField!
    
    var delegate: UITableViewCellUpdateDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func textPhraseValueChanged(sender: AnyObject) {
        
        self.delegate?.cellDidChangeValue(self)
        
    }

}
