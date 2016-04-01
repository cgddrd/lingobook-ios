//
//  PhraseTableViewCell.swift
//  LingoBook
//
//  Created by Connor Goddard on 24/03/2016.
//  Copyright © 2016 Connor Goddard. All rights reserved.
//

import UIKit

class PhraseTableViewCell: UITableViewCell {

    @IBOutlet weak var labelOriginPhrase: UILabel!
    
    @IBOutlet weak var labelTranslatedPhrase: UILabel!
    
    @IBOutlet weak var labelTags: UILabel!
    
    @IBOutlet weak var btnAddRevision: UIButton!
    
    @IBOutlet weak var btnSpeak: UIButton!
    
    @IBAction func btnRevisionPressed(sender: AnyObject) {
        
        self.setRevisionButtonStyleDelete()
        
    }
    
    let activeColour = UIColor(red: 251.0/255.0, green: 251.0/255.0, blue: 251.0/255.0, alpha: 1.0);
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    func setRevisionButtonStyleDelete() {
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.btnAddRevision.backgroundColor = UIColor.flatWatermelonColor()
            
            if let image = UIImage(named: "glasses-filled") {
                self.btnAddRevision.setImage(image, forState: .Normal)
            }
        })
    
    }
    
    func setActiveState(active: Bool, animated: Bool, isEditing: Bool = false) {
        
        if active {
            
            self.btnAddRevision.hidden = false
            
            if !isEditing {
                
                if animated {
                    self.btnSpeak.slideInFromRight(0.3, completionDelegate: self)
                }
                
                self.labelTranslatedPhrase.hidden = false
                self.labelTags.hidden = false
                self.btnSpeak.hidden = false
                
                self.contentView.backgroundColor = activeColour
                
            }
            
        } else {
            
            if animated {
                self.btnSpeak.slideInFromLeft(0.3, completionDelegate: self)
            }
            
            self.btnAddRevision.hidden = isEditing
            self.btnSpeak.hidden = true
            self.labelTranslatedPhrase.hidden = true
            self.labelTags.hidden = true
            
            self.contentView.backgroundColor = UIColor.clearColor()
            
        }
        

        
    }

}
