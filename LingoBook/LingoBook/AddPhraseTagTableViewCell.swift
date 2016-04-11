//
//  AddPhraseTagTableViewCell.swift
//  LingoBook
//
//  Student No: 110024253
//

import UIKit

// Represents a prototype cell used for inputting dynamic data values (e.g. tags).
class AddPhraseTagTableViewCell: UITableViewCell {
    
    @IBOutlet weak var textTag: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
