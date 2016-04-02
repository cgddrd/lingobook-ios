//
//  FlashViewController.swift
//  LingoBook
//
//  Created by Connor Goddard on 02/04/2016.
//  Copyright © 2016 Connor Goddard. All rights reserved.
//

import UIKit

class FlashViewController: UIViewController {
    
    var message: String = "Good Morning"

    @IBOutlet weak var testView: UIView!
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var answerLabel: UILabel!
    
    @IBOutlet weak var placeholderLabel: UILabel!
    
    @IBAction func cardButtonPressed(sender: AnyObject) {
        
        if self.answerLabel.hidden == true {
            
            self.answerLabel.slideInFromBottom(0.4)
            
            UIView.animateWithDuration(0.2, animations: {
                
                self.placeholderLabel.alpha = 0.0
                self.answerLabel.alpha = 1.0
                self.answerLabel.hidden = false
                
            })
            
        } else {
            
            self.answerLabel.slideInFromTop(0.4)
            
            UIView.animateWithDuration(0.2, animations: {
                self.answerLabel.alpha = 0.0
                self.answerLabel.hidden = true
                self.placeholderLabel.alpha = 1.0
            })
            
        }
        

        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.questionLabel.text = message
        self.answerLabel.hidden = true
        self.answerLabel.alpha = 0.0
        
        testView.layer.cornerRadius = 8.0
        //testView.clipsToBounds = true
        testView.layer.shadowColor = UIColor.blackColor().CGColor
        testView.layer.shadowOffset = CGSizeMake(5, 5)
        testView.layer.shadowOpacity = 0.1
        testView.layer.shadowRadius = 5
        
        let border = CALayer()
        
        border.frame = CGRectMake(0.0, self.questionLabel.frame.size.height - 2, self.questionLabel.frame.width, 2.0)
        
        border.backgroundColor = UIColor.flatWhiteColorDark().CGColor
        
        self.questionLabel.layer.addSublayer(border)
        
        self.questionLabel.layer.sublayers?.first?.backgroundColor = UIColor.brownColor().CGColor
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
