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
    
    var dataController = DataController()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        dataSource = self
        delegate = self
    
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)

        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        
        self.revisionPhrases = appDel.revisionPhrases
        
        self.orderedViewControllers.removeAll()
        
        if self.revisionPhrases != nil && self.revisionPhrases?.count > 0 {
            
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
                               animated: false,
                               completion: nil)
            
            
            // See: http://stackoverflow.com/a/17330606/4768230 for an explanation of why we have to do this.
//            setViewControllers(
//                [firstViewController],
//                direction: UIPageViewControllerNavigationDirection.Forward,
//                animated: true,
//                completion: { [weak self] (finished: Bool) in
//                    
//                    if finished {
//                        
//                        dispatch_async(dispatch_get_main_queue(), {
//                            
//                            self!.setViewControllers(
//                                [firstViewController],
//                                direction: UIPageViewControllerNavigationDirection.Forward,
//                                animated: false,
//                                completion: nil
//                            )
//                            
//                        })
//                    }
//                    
//                })
            
        }
        
        revisionDelegate?.revisionPageViewController(self, didUpdatePageCount: orderedViewControllers.count)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

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

// The 'class' keyword here sets this protocol to be a 'Class-Only' protocol. (i.e. only class types can adopt the protocol (structs or enums couldn't).
// See: https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Protocols.html#//apple_ref/doc/uid/TP40014097-CH25-ID281 for more information.
protocol RevisionPageViewControllerDelegate: class {
    
    func revisionPageViewController(revisionPageViewController: RevisionPageViewController, didUpdatePageCount count: Int)
    
    func revisionPageViewController(revisionPageViewController: RevisionPageViewController, didUpdatePageIndex index: Int)
    
}
