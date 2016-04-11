//
//  FlashCardViewController.swift
//  LingoBook
//
//  Student No: 110024253
//

import UIKit

// View controller for representing an individual flashcard (managed by 'RevisionPageViewController')
class FlashCardViewController: UIViewController {
    
    var question: String = ""
    var answer: String = ""
    
    // Child-view representing the flashcard itself.
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var answerLabel: UILabel!
    
    @IBOutlet weak var placeholderLabel: UILabel!
    
    @IBAction func cardButtonPressed(sender: AnyObject) {
        
        if self.answerLabel.hidden == true {
            
            // Perform slide down animation.
            self.answerLabel.slideInFromBottom(0.4)
            
            // Animate opacity.
            UIView.animateWithDuration(0.2, animations: {
                
                self.placeholderLabel.alpha = 0.0
                self.answerLabel.alpha = 1.0
                self.answerLabel.hidden = false
                
            })
            
        } else {
            
            // Perform slide up animation.
            self.answerLabel.slideInFromTop(0.4)
            
            // Animate transparency.
            UIView.animateWithDuration(0.2, animations: {
                self.answerLabel.alpha = 0.0
                self.answerLabel.hidden = true
                self.placeholderLabel.alpha = 1.0
            })
            
        }
        
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.questionLabel.text = question
        self.answerLabel.text = answer
        self.answerLabel.hidden = true
        self.answerLabel.alpha = 0.0
        
        // Set up the styling of the child view to appear like a flashcard.
        cardView.layer.cornerRadius = 8.0
        cardView.layer.shadowColor = UIColor.blackColor().CGColor
        cardView.layer.shadowOffset = CGSizeMake(5, 5)
        cardView.layer.shadowOpacity = 0.1
        cardView.layer.shadowRadius = 5
        
        // Add a BOTTOM BORDER ONLY to the question label (provides the horizontal line)
        let labelBorder = CALayer()
        labelBorder.frame = CGRectMake(0.0, self.questionLabel.frame.size.height - 2, self.questionLabel.frame.width, 2.0)
        labelBorder.backgroundColor = UIColor.flatWhiteColorDark().CGColor
        self.questionLabel.layer.addSublayer(labelBorder)
        
        // Do any additional setup after loading the view.
    }

}
