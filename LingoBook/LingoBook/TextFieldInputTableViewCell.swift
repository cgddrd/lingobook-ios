//
//  TextFieldInputTableViewCell.swift
//  LingoBook
//
//  Student No: 110024253
//

import UIKit

// Represents a UITableViewCell that supports text input via a UITextField.
class TextFieldInputTableViewCell: UITableViewCell {

    @IBOutlet weak var textPhrase: UITextField!
    
    var delegate: UITableViewInputCellUpdateDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // This function is triggered everytime the UITextField is updated.
    @IBAction func textPhraseValueChanged(sender: AnyObject) {
        
        self.delegate?.cellDidChangeValue(self)
        
    }

}
