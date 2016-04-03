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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    }
    
    func revisionPageViewController(revisionPageViewController: RevisionPageViewController,
                                    didUpdatePageIndex index: Int) {
        pageDots.currentPage = index
    }
    
}
