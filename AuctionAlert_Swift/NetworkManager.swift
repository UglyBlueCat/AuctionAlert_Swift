//
//  NetworkManager.swift
//  AuctionAlert_Swift
//
//  Created by Robin Spinks on 07/09/2016.
//  Copyright © 2016 UglyBlueCat. All rights reserved.
//

import Foundation

class NetworkManager {
    
    let defaultSession : URLSession
    var testVariable : Int // something to test against
    
    /*
     * Create a shared instance to initialise class as a singleton
     * originally taken from: http://krakendev.io/blog/the-right-way-to-write-a-singleton
     */
    static let sharedInstance = NetworkManager()
    fileprivate init() {
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 300.0
        
        self.defaultSession = URLSession(configuration: configuration)
        
        self.testVariable = 0
    }
        
    /**
     Handles an HTTP request of any type
     
     - parameters:
        - request: The HTTP request
        - completion: A method to handle the returned data
     */
    func handleRequest (request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        let task : URLSessionDataTask = defaultSession.dataTask(with: request, completionHandler: completion)
        task.resume()
    }

}
