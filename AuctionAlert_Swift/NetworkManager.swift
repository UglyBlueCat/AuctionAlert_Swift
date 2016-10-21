//
//  NetworkManager.swift
//  IGTDevTask
//
//  Created by Robin Spinks on 07/09/2016.
//  Copyright © 2016 UglyBlueCat. All rights reserved.
//

import Foundation

class NetworkManager {
    
    let defaultSession : NSURLSession
    
    /*
     * Create a shared instance to initialise class as a singleton
     * originally taken from: http://krakendev.io/blog/the-right-way-to-write-a-singleton
     */
    static let sharedInstance = NetworkManager()
    private init() {
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForRequest = 300.0
        
        self.defaultSession = NSURLSession(configuration: configuration)
    }
        
    /*
     * handleRequest
     *
     * Handles an NSURLRequest of whatever type
     *
     * This gives me the ability to expand the class to handle different request methods
     * e.g. For RESTful API interaction
     *
     * @param: request: NSURLRequest - The URL request
     * @param: completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void)
     *         - A method to handle the returned data
     */
    func handleRequest (request: NSURLRequest, completion: (NSData?, NSURLResponse?, NSError?) -> Void) {
        
        let task : NSURLSessionDataTask = defaultSession.dataTaskWithRequest(request, completionHandler: completion) 
        task.resume()
    }

}
