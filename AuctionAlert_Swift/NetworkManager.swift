//
//  NetworkManager.swift
//  IGTDevTask
//
//  Created by Robin Spinks on 07/09/2016.
//  Copyright © 2016 UglyBlueCat. All rights reserved.
//

import Foundation

class NetworkManager {
    
    let defaultSession : NSURLSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    
    /*
     * Create a shared instance to initialise class as a singleton
     * originally taken from: http://krakendev.io/blog/the-right-way-to-write-a-singleton
     */
    static let sharedInstance = NetworkManager()
    private init() {}
    
    /*
     * fetchJackpotList
     *
     * Downloads a list of games and their jackpots 
     */
    func fetchJackpotList () {
        
        guard let jackpotURL : NSURL = NSURL(string: jackpotURLString) else {
            DLog("Cannot initialise jackpot URL: \(jackpotURLString)")
            return
        }
        
        let jackPotURLRequest : NSURLRequest = NSURLRequest(URL: jackpotURL) 
        
        downloadData(jackPotURLRequest)
    }
    
    /*
     * downloadData
     *
     * Downloads data from a given URL request
     *
     * It would make more sense for the completion method to be passed to this method as it handles the data
     * in a way that is specific to parsing jackpot data, but that would leave this method empty.
     * I want this method to show the distinction of having a method specifically for download requests
     * There could be other methods for other types of requests; we just don't need them in this case
     *
     * @param: request: NSURLRequest - The URL request to download data from
     */
    func downloadData (request: NSURLRequest) {
        
        handleRequest(request, completion: { (data, urlResponse, error) in
            guard error == nil else {
                DLog("Download error: \(error!.description)")
                return
            }
            
            if data != nil {
                FileHandler.sharedInstance.writeDataToFile(data!)
            } else {
                DLog("Null data")
            }
        })
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
