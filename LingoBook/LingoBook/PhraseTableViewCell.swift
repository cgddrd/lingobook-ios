//
//  PhraseTableViewCell.swift
//  LingoBook
//
//  Student No: 110024253
//

import UIKit
import AVFoundation

// Represents an individual custom phrasebook table view cell.

// AVSpeechSynthesizerDelegate provides access to text-to-speech functionality provided within the 'AVFoundation' library.
class PhraseTableViewCell: UITableViewCell, AVSpeechSynthesizerDelegate {

    @IBOutlet weak var labelOriginPhrase: UILabel!
    
    @IBOutlet weak var labelTranslatedPhrase: UILabel!
    
    @IBOutlet weak var labelTags: UILabel!
    
    @IBOutlet weak var btnAddRevision: UIButton!
    
    @IBOutlet weak var btnSpeak: UIButton!
    
    var delegate: PhraseTableViewCellDelegate?
    
    var indexPath: NSIndexPath?
    
    let activeColour = UIColor(red: 251.0/255.0, green: 251.0/255.0, blue: 251.0/255.0, alpha: 1.0);
    
    // Instantiate a new speech synthesizer.
    let synth = AVSpeechSynthesizer()
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        // Initialization code
        
        // By default, Add Revision button is set to green.
        self.btnAddRevision.backgroundColor = UIColor.flatGreenColor()
        
        // Add Revision button should always be visible (except in edit mode)
        self.btnAddRevision.hidden = false
        
        synth.delegate = self
        
    }
    
    @IBAction func btnSpeakPressed(sender: AnyObject) {
        
        // Update Speaker button icon to display the filled varient.
        if let image = UIImage(named: "speaker-filled") {
            self.btnSpeak.setImage(image, forState: .Normal)
        }
        
        // Setup the text string that we wish AVSpeechSynthesizer to read aloud.
        let utterance = AVSpeechUtterance(string: "\(self.labelOriginPhrase.text!)--\(self.labelTranslatedPhrase.text!)")
        
        // Set the speech rate (not too fast).
        utterance.rate = 0.4
        
        // Perform the text-to-speech.
        synth.speakUtterance(utterance)
        
    }
    
    // AVSpeechSynthesizerDelegate function for hooking into the end of a text-to-speech action.
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didFinishSpeechUtterance utterance: AVSpeechUtterance) {
        
        // Once the text-to-speech has finished, reset the Speaker button image back to the original line-only icon.
        if let image = UIImage(named: "speaker") {
            self.btnSpeak.setImage(image, forState: .Normal)
        }
        
    }
    
    @IBAction func btnRevisionPressed(sender: AnyObject) {
        
        if delegate != nil {
            
            // Call the delgate function for Add Revision button press (handled by PhrasesViewController)
            delegate?.addRevisionButtonPressed(self, indexPath: indexPath!)
            
        }
        
        
    }
    
    // Sets the style state for the Add Revision button.
    func setRevisionButtonStyle(isAddEvent: Bool) {
        
        // If we are adding a phrase to the revision list, set the colour to red, otherwise set to green.
        let buttonColour = isAddEvent ? UIColor.flatWatermelonColor() : UIColor.flatGreenColor()
        
        // If we are adding a phrase to the revision list, set the icon to filled, otherwise set to line-only.
        let buttonImage = isAddEvent ? "glasses-filled" : "glasses"
        
        // Animate the style change.
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            
            self.btnAddRevision.backgroundColor = buttonColour
            
            if let image = UIImage(named: buttonImage) {
                self.btnAddRevision.setImage(image, forState: .Normal)
            }
            
        })
    
    }
    
    // Shows or hides particular cell contents based on whether or not the cell is about to enter edit mode.
    func setEditState(editing: Bool) {
        
        // If we leave edit mode, only the Add Revision button should be re-displayed (due to all cells initially being in a collapsed state).
        self.btnAddRevision.hidden = editing
        
        self.contentView.backgroundColor = UIColor.clearColor()
        
        if editing {
            
            // Hide all other content from the cell.
            self.labelTranslatedPhrase.hidden = true
            self.labelTags.hidden = true
            self.btnSpeak.hidden = true
            
        }
    
    }
    
    // Shows or hides cell content based on whether the cell is about to become the new selected cell.
    func setSelectedState(active: Bool, animated: Bool = true) {
        
        // Set 'hidden' to false, if 'active' is true (and vice-versa).
        self.labelTranslatedPhrase.hidden = !active
        self.labelTags.hidden = !active
        self.btnSpeak.hidden = !active
        
        // Set the background colour to gray if active, otherwsie clear.
        self.contentView.backgroundColor = active ? activeColour : UIColor.clearColor()
        
        // Check if we want to animate the Speaker button appearance.
        if animated {
            
            if active {
                
                // If cell is selected, reveal Speaker button from right to left.
                self.btnSpeak.slideInFromRight(0.3, completionDelegate: self)
                
            } else {
                
                // Otherwise, hide Speaker button from left to right.
                self.btnSpeak.slideInFromLeft(0.3, completionDelegate: self)
                
            }
            
        }
        
    }

}
