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
    
    @IBOutlet weak var imageSpeak: UIImageView!
    
    @IBOutlet weak var imageRevisionStatus: UIImageView!
    
    @IBOutlet weak var imageArrow: UIImageView!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()

        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
