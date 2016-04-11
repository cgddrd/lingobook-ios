//
//  RevisionViewController.swift
//  LingoBook
//
//  Student No: 110024253
//

import UIKit

// Represents the parent UIViewController for the child UIPageViewController (embedded as a Container View).
class RevisionViewController: UIViewController, RevisionPageViewControllerDelegate {

    @IBOutlet weak var pageDots: UIPageControl!
    
    // Container View for embedded either RevisionPageViewController or EmptyRevisionListController into current VC.
    @IBOutlet weak var containerView: UIView!
    
    // Obtain a reference to the View Controller containing the 'empty list' placeholder message.
    let emptyListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("EmptyRevisionListController")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let revisionPageViewController = segue.destinationViewController as? RevisionPageViewController {
            
            // Set up the delegate for the embedded UIPageViewController.
            revisionPageViewController.revisionDelegate = self
        }
        
    }
    
    // RevisionPageViewControllerDelegate function that fires whenever the internal page count for the UIPageViewController is updated.
    // Modified from original source: https://spin.atomicobject.com/2015/12/23/swift-uipageviewcontroller-tutorial/
    func revisionPageViewController(revisionPageViewController: RevisionPageViewController, didUpdatePageCount count: Int) {
        
        // Set the number of dots in the Page Control.
        pageDots.numberOfPages = count
        
        // If the number of revision items is zero, then remove the UIPageViewController and replace with the 'empty list' message.
        if count <= 0 {
            
            pageDots.hidden = true
            
            self.addChildViewController(emptyListVC)
            emptyListVC.view.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height);
            self.containerView.addSubview(emptyListVC.view)
            
            emptyListVC.didMoveToParentViewController(self)
        
        // Otherwise, remove the 'empty list' message, and replace with the UIPageViewController.
        } else {
            
            if self.containerView.subviews.contains(emptyListVC.view) {
                
                emptyListVC.didMoveToParentViewController(nil)
                emptyListVC.view.removeFromSuperview()
                emptyListVC.removeFromParentViewController()
                
                pageDots.hidden = false
                
            }
            
            
        }
    }
    
    // RevisionPageViewControllerDelegate function that fires everytime the user swipes to a new page.
    // Modified from original source: https://spin.atomicobject.com/2015/12/23/swift-uipageviewcontroller-tutorial/
    func revisionPageViewController(revisionPageViewController: RevisionPageViewController, didUpdatePageIndex index: Int) {
        pageDots.currentPage = index
    }

}
