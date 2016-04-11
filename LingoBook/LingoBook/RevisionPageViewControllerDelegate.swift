//
//  RevisionPageViewControllerDelegate.swift
//  LingoBook
//
//  Student No: 110024253
//

// Delegate for relaying information relating to the pages managed by UIPageViewController up to parent controller (RevisionPageViewController).
// Modified from original source: https://spin.atomicobject.com/2015/12/23/swift-uipageviewcontroller-tutorial/

// The 'class' keyword here sets this protocol to be a 'Class-Only' protocol. (i.e. only class types can adopt the protocol (structs or enums couldn't).
// See: https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Protocols.html#//apple_ref/doc/uid/TP40014097-CH25-ID281 for more information.
protocol RevisionPageViewControllerDelegate: class {
    
    func revisionPageViewController(revisionPageViewController: RevisionPageViewController, didUpdatePageCount count: Int)
    
    func revisionPageViewController(revisionPageViewController: RevisionPageViewController, didUpdatePageIndex index: Int)
    
}
