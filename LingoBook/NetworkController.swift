//
//  NetworkController.swift
//  LingoBook
//
//  Created by Connor Goddard on 26/03/2016.
//  Copyright © 2016 Connor Goddard. All rights reserved.
//

import Foundation
import UIKit

class NetworkController {
    
    var session: NSURLSession?
    
    func performFileDownload(url: String, completion: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        session = NSURLSession(configuration: configuration)
        
        let url = NSURL(string: url)
        
        // let task = session!.dataTaskWithURL(url!, completionHandler: {
        //    
        //    (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
        //    
        //    completion(data: data, response: response, error: error)
        //    
        // })
        
        // This is known as a TRAILING CLOSURE. It's equivalent to the example above, but uses slightly different syntax to define the closure.
        // See: http://www.learnswift.io/blog/2014/6/9/writing-completion-blocks-with-closures-in-swift for more information.
        let task = session!.dataTaskWithURL(url!) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            // Call the completion handler via the closure.
            completion(data: data, response: response, error: error)
            
            self.session?.finishTasksAndInvalidate()
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
        }
        
        // task.resume is used to start the process to load the URL.
        task.resume()
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
    }
    
    
    
}
