//
//  RevisionPageViewController.swift
//  LingoBook
//
//  Created by Connor Goddard on 02/04/2016.
//  Copyright © 2016 Connor Goddard. All rights reserved.
//

import UIKit

class RevisionPageViewController: UIPageViewController {
    
    var revisionPhrases: [String : OriginPhrase]?
    
     var orderedViewControllers = [UIViewController]()
    
    private func newColoredViewController() -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CardViewController")
    }
    
    weak var revisionDelegate: RevisionPageViewControllerDelegate?
    
    var dataController = DataController.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        self.orderedViewControllers = [UIViewController]()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        
        self.revisionPhrases = appDel.revisionPhrases
        
        self.orderedViewControllers = [UIViewController]()
        
        if self.revisionPhrases != nil {
            
            for (_, phrase) in self.revisionPhrases! {
                
                let test = newColoredViewController() as! FlashViewController
                test.question = phrase.textValue!
                test.answer = (phrase.getFirstTranslation()?.textValue)!
                self.orderedViewControllers.append(test)
                
            }
        }
        
        if let firstViewController = self.orderedViewControllers.first {
            
            setViewControllers([firstViewController],
                               direction: UIPageViewControllerNavigationDirection.Forward,
                               animated: true,
                               completion: nil)
            
        }
        
        revisionDelegate?.revisionPageViewController(self, didUpdatePageCount: orderedViewControllers.count)
        
        super.viewWillAppear(animated)
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

extension RevisionPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
            guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
                return nil
            }
            
            let nextIndex = viewControllerIndex + 1
            let orderedViewControllersCount = orderedViewControllers.count
            
            guard orderedViewControllersCount != nextIndex else {
                return nil
            }
            
            guard orderedViewControllersCount > nextIndex else {
                return nil
            }
            
            return orderedViewControllers[nextIndex]
        
    }
    
}

extension RevisionPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let firstViewController = viewControllers?.first,
            
            let index = orderedViewControllers.indexOf(firstViewController) {
            
            revisionDelegate?.revisionPageViewController(self,
                                                         didUpdatePageIndex: index)
            
        }
    }
    
}

protocol RevisionPageViewControllerDelegate: class {
    
    /**
     Called when the number of pages is updated.
     
     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter count: the total number of pages.
     */
    func revisionPageViewController(revisionPageViewController: RevisionPageViewController,
                                    didUpdatePageCount count: Int)
    
    /**
     Called when the current index is updated.
     
     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter index: the index of the currently visible page.
     */
    func revisionPageViewController(revisionPageViewController: RevisionPageViewController,
                                    didUpdatePageIndex index: Int)
    
}
