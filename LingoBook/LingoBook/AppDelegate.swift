//
//  AppDelegate.swift
//  LingoBook
//
//  Student No: 110024253
//

import UIKit
import CoreData
import ChameleonFramework

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // 'Bariol' font used under license:
    let appFont = UIFont (name: "Bariol", size: 20);
    
    // Color pallette providide by Chameleon Framework. See: https://github.com/ViccAlexander/Chameleon
    let barTintColour = UIColor.flatYellowColor()
    let barTextColour = UIColor.init(contrastingBlackOrWhiteColorOn: UIColor.flatYellowColor(), isFlat: true)
    
    // Initialise collection of revision phrases.
    var revisionPhrases = [String : OriginPhrase]()
    
    var dataController = DataController()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Override point for customization after application launch.
        
        // Set custom font for navigation bar.
        if (appFont != nil) {
            UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: appFont!, NSForegroundColorAttributeName: barTextColour]
        }
        
        // Override navigation bar colour for entire app.
        UINavigationBar.appearance().barTintColor = barTintColour
        UINavigationBar.appearance().tintColor = barTextColour
        
        
        // Load saved revision phrases (if available) from NSUserDefaults.
        if let loadedPhrases = dataController.loadSavedRevisionPhrases() {
            
            self.revisionPhrases = loadedPhrases
            
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        // Save main CD object graph.
        dataController.coreDataStack.saveContext()
        
        // Save any selected revision phrases to NSUserDefaults.
        dataController.saveRevisionPhrases(self.revisionPhrases)
        
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        
        // Save main CD object graph.
        dataController.coreDataStack.saveContext()
        
        // Save any selected revision phrases to NSUserDefaults.
        dataController.saveRevisionPhrases(self.revisionPhrases)
        
    }
    
}
