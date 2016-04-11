//
//  TextViewInputTableViewCell.swift
//  LingoBook
//
//  Student No: 110024253
//

import UIKit

// Represents a UITableViewCell that supports text input via a UITextField.
class TextViewInputTableViewCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var textPhraseNote: UITextView!
    
    var delegate: UITableViewInputCellUpdateDelegate?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        
        // Set-up the delegate for dtecting changes to UITextView content.
        textPhraseNote.delegate = self
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // This function is triggered everytime the UITextView is updated.
    func textViewDidChange(textView: UITextView) {
        
        self.delegate?.cellDidChangeValue(self)
    }

}
