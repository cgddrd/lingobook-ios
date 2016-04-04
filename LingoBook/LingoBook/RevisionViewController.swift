//
//  RevisionViewController.swift
//  LingoBook
//
//  Created by Connor Goddard on 02/04/2016.
//  Copyright © 2016 Connor Goddard. All rights reserved.
//

import UIKit

class RevisionViewController: UIViewController {

    @IBOutlet weak var pageDots: UIPageControl!
    @IBOutlet weak var containerView: UIView!
    
    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TestController")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Reset page dots ready for new collection of flash cards to be displayed.
        //self.pageDots.currentPage = 0
        //self.pageDots.numberOfPages = 0
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        
//        for vc in self.containerView.subviews {
//            
//            vc.removeFromSuperview()
//            
//        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let tutorialPageViewController = segue.destinationViewController as? RevisionPageViewController {
            tutorialPageViewController.revisionDelegate = self
        }
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

extension RevisionViewController: RevisionPageViewControllerDelegate {
    
    func revisionPageViewController(revisionPageViewController: RevisionPageViewController,
                                    didUpdatePageCount count: Int) {
        
        pageDots.numberOfPages = count
        
        if count <= 0 {
            
            pageDots.hidden = true
            
            self.addChildViewController(vc)
            vc.view.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height);
            self.containerView.addSubview(vc.view)
            
            vc.didMoveToParentViewController(self)
            
        } else {
            
            if self.containerView.subviews.contains(vc.view) {
                
                vc.didMoveToParentViewController(nil)
                vc.view.removeFromSuperview()
                vc.removeFromParentViewController()
                
                pageDots.hidden = false
                
            }
            
            
        }
    }
    
    func revisionPageViewController(revisionPageViewController: RevisionPageViewController,
                                    didUpdatePageIndex index: Int) {
        pageDots.currentPage = index
    }
    
}
