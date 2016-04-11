//
//  RevisionPageViewController.swift
//  LingoBook
//
//  Student No: 110024253
//


import UIKit

// Represents the UIPageViewController used to house and manage the collection of FlashCardViewControllers.
class RevisionPageViewController: UIPageViewController {
    
    // The collection of phrases to be displayed as flashcards.
    var revisionPhrases: [String : OriginPhrase]?
    
    var childFlashCardViewControllers = [UIViewController]()
    
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

        // Obtain an updated list of revision phrases from the central collection.
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        self.revisionPhrases = appDel.revisionPhrases
        
        // Make sure to clear the exisiting collection of FlashCardViewControllers.
        self.childFlashCardViewControllers.removeAll()
        
        // If we have at least one revision phrase in the collection, create the new FlashCardViewControllers.
        if self.revisionPhrases != nil && self.revisionPhrases?.count > 0 {
            
            for (_, phrase) in self.revisionPhrases! {
                
                // Instantiate a new instance of FlashCardViewController from the Storyboard.
                let newCard = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("FlashCardViewController") as! FlashCardViewController
                
                // Set the card contents.
                newCard.question = phrase.textValue!
                newCard.answer = (phrase.getFirstTranslation()?.textValue)!
                
                // Add the new flash card to the collection.
                self.childFlashCardViewControllers.append(newCard)
                
            }
        }
        
        // Set up the collection of FlashCardViewControllers and display the first on screen.
        // Modified from original source: https://spin.atomicobject.com/2015/12/23/swift-uipageviewcontroller-tutorial/
        if let firstViewController = self.childFlashCardViewControllers.first {
            
            // The 'animated' parameter HAS TO BE SET TO FALSE.
            // See: http://stackoverflow.com/a/17330606/4768230 for an explanation of why.
            setViewControllers([firstViewController],
                               direction: UIPageViewControllerNavigationDirection.Forward,
                               animated: false,
                               completion: nil)
        }
        
        // Update the page count for the Page Control.
        revisionDelegate?.revisionPageViewController(self, didUpdatePageCount: childFlashCardViewControllers.count)

        
    }

}

// Extension methods providing required data source functions for UIPageViewController.
// Modified from original source: https://spin.atomicobject.com/2015/12/23/swift-uipageviewcontroller-tutorial/
extension RevisionPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = childFlashCardViewControllers.indexOf(viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard childFlashCardViewControllers.count > previousIndex else {
            return nil
        }
        
        return childFlashCardViewControllers[previousIndex]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
            guard let viewControllerIndex = childFlashCardViewControllers.indexOf(viewController) else {
                return nil
            }
            
            let nextIndex = viewControllerIndex + 1
        
            let orderedViewControllersCount = childFlashCardViewControllers.count
            
            guard orderedViewControllersCount != nextIndex else {
                return nil
            }
            
            guard orderedViewControllersCount > nextIndex else {
                return nil
            }
            
            return childFlashCardViewControllers[nextIndex]
        
    }
    
}

// Extension methods providing required delegate functions for UIPageViewController.
// Modified from original source: https://spin.atomicobject.com/2015/12/23/swift-uipageviewcontroller-tutorial/
extension RevisionPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let firstViewController = viewControllers?.first,
            
            let index = childFlashCardViewControllers.indexOf(firstViewController) {
            
            revisionDelegate?.revisionPageViewController(self, didUpdatePageIndex: index)
            
        }
    }
    
}
