//
//  API_Interface.swift
//  AuctionAlert_Swift
//
//  Created by Robin Spinks on 12/07/2016.
//  Copyright © 2016 UglyBlueCat. All rights reserved.
//

import Foundation
import Alamofire

class API_Interface {
    
    /*
     * searchAuction
     *
     * Initiates a search API call for an object in a realm
     *
     * @param: realm:   String - The realm to search in
     * @param: object:  String - The object to search for
     */
    class func searchAuction (realm: String, object: String, price: String) {
        let params: Dictionary = ["command": "search", "realm": realm, "object_name": object, "price": price]
        self.getRequest(params)
    }
    
    /*
     * getRequest
     *
     * Calls a request with the GET method
     *
     * @param: params: Dictionary<String, String> - The parameters for the GET request
     */
    class func getRequest (params: Dictionary<String, String>) {
        self.makeRequest(.GET, params: params)
    }
    
    /*
     * makeRequest
     *
     * Makes an HTTP request with the provided parameterd
     *
     * @param: method: Alamofire.Method             - The method for the request
     * @param: params: Dictionary<String, String>   - The parameters for the request
     */
    class func makeRequest (method: Alamofire.Method, params: Dictionary<String, String>) {
        let baseURL: String = "http://uglybluecat.com/AuctionAlert.php"
        
        Alamofire.request(method, baseURL, parameters: params)
            .validate()
            .progress({ (read, total, expected) in
                DLog("read: \(read) total: \(total) expected: \(expected)")
            })
            .responseJSON { response in
                switch response.result {
                case .Success:
                    DataHandler.sharedInstance.newData(response.data!)
                case .Failure(let error):
                    DLog("Error: \(error)")
                }
        }
    }
}
