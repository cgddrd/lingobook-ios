//
//  AddPhraseNoteTableViewCell.swift
//  LingoBook
//
//  Created by Connor Goddard on 23/03/2016.
//  Copyright © 2016 Connor Goddard. All rights reserved.
//

import UIKit

class TextViewInputTableViewCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var textPhraseNote: UITextView!
    
    var delegate: UITableViewCellUpdateDelegate?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        
        textPhraseNote.delegate = self
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textViewDidChange(textView: UITextView) {
        
        self.delegate?.cellDidChangeValue(self)
    }

}
