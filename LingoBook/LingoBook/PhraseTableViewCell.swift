//
//  PhraseTableViewCell.swift
//  LingoBook
//
//  Created by Connor Goddard on 24/03/2016.
//  Copyright © 2016 Connor Goddard. All rights reserved.
//

import UIKit
import AVFoundation

class PhraseTableViewCell: UITableViewCell, AVSpeechSynthesizerDelegate {

    @IBOutlet weak var labelOriginPhrase: UILabel!
    
    @IBOutlet weak var labelTranslatedPhrase: UILabel!
    
    @IBOutlet weak var labelTags: UILabel!
    
    @IBOutlet weak var btnAddRevision: UIButton!
    
    @IBOutlet weak var btnSpeak: UIButton!
    
    var delegate: PhraseTableViewCellDelegate?
    
    var indexPath: NSIndexPath?
    
    let activeColour = UIColor(red: 251.0/255.0, green: 251.0/255.0, blue: 251.0/255.0, alpha: 1.0);
    
    let synth = AVSpeechSynthesizer()
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        // Initialization code
        
        self.btnAddRevision.backgroundColor = UIColor.flatGreenColor()
        self.btnAddRevision.hidden = false
        
        synth.delegate = self
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    @IBAction func btnSpeakPressed(sender: AnyObject) {
        
        if let image = UIImage(named: "speaker-filled") {
            self.btnSpeak.setImage(image, forState: .Normal)
        }
        
        let utterance = AVSpeechUtterance(string: "\(self.labelOriginPhrase.text!)--\(self.labelTranslatedPhrase.text!)")
        utterance.rate = 0.3
        synth.speakUtterance(utterance)
        
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didFinishSpeechUtterance utterance: AVSpeechUtterance) {
        
        if let image = UIImage(named: "speaker") {
            self.btnSpeak.setImage(image, forState: .Normal)
        }
        
    }
    
    @IBAction func btnRevisionPressed(sender: AnyObject) {
        
        if delegate != nil {
            
            delegate?.addRevisionButtonPressed(self, indexPath: indexPath!)
            
        }
        
        
    }
    
    func setRevisionButtonStyle(isAddEvent: Bool) {
        
        let buttonColour = isAddEvent ? UIColor.flatWatermelonColor() : UIColor.flatGreenColor()
        let buttonImage = isAddEvent ? "glasses-filled" : "glasses"
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            
            self.btnAddRevision.backgroundColor = buttonColour
            
            if let image = UIImage(named: buttonImage) {
                self.btnAddRevision.setImage(image, forState: .Normal)
            }
            
        })
    
    }
    
    func setEditState(editing: Bool) {
        
        self.btnAddRevision.hidden = editing
        
        if editing {
            
            self.labelTranslatedPhrase.hidden = true
            self.labelTags.hidden = true
            self.btnSpeak.hidden = true
            
        }
    
    }
    
    func setSelectedState(active: Bool, animated: Bool = true) {
    
        self.labelTranslatedPhrase.hidden = !active
        self.labelTags.hidden = !active
        self.btnSpeak.hidden = !active
        
        self.contentView.backgroundColor = active ? activeColour : UIColor.clearColor()
        
        if animated {
            
            if active {
                
                self.btnSpeak.slideInFromRight(0.3, completionDelegate: self)
                
            } else {
                
                self.btnSpeak.slideInFromLeft(0.3, completionDelegate: self)
                
            }
            
        }
        
    }

}
