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
    
    @IBAction func btnRevisionPressed(sender: AnyObject) {
        
        self.setRevisionButtonStyleDelete()
        
    }
    
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

}
