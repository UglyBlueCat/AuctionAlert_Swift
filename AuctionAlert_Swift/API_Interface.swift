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
        self.getRequest(params, urlString: auctionAlertURL)
    }
    
    /*
     * saveSearch
     *
     * Saves a search for an object in a realm
     * This will result in a push notification if the object is found by the server
     *
     * @param: realm:   String - The realm to search in
     * @param: object:  String - The object to search for
     */
    class func saveSearch (realm: String, object: String, price: String) {
        let params: Dictionary = ["command": "save", "realm": realm, "object_name": object, "price": price]
        self.postRequest(params, urlString: auctionAlertURL)
    }
    
    /*
     * getRequest
     *
     * Calls a request with the GET method
     *
     * @param: params: Dictionary<String, String> - The parameters for the GET request
     */
    class func getRequest (params: Dictionary<String, String>, urlString: String) {
        self.makeRequest(.GET, params: params, urlString: urlString)
    }
    
    /*
     * postRequest
     *
     * Calls a request with the POST method
     *
     * @param: params: Dictionary<String, String> - The parameters for the POST request
     */
    class func postRequest (params: Dictionary<String, String>, urlString: String) {
        self.makeRequest(.POST, params: params, urlString: urlString)
    }
    
    /*
     * makeRequest
     *
     * Makes an HTTP request with the provided parameters
     *
     * @param: method: Alamofire.Method             - The method for the request
     * @param: params: Dictionary<String, String>   - The parameters for the request
     */
    class func makeRequest (method: Alamofire.Method, params: Dictionary<String, String>, urlString: String) {
        var localParams = params
        if idForVendor != nil {
            localParams.updateValue(idForVendor!, forKey: "idforvendor")
        } else {
            DLog("No ID for Vendor")
            return
        }
        
        Alamofire.request(method, urlString, parameters: localParams)
            .validate()
            .progress({ (read, total, expected) in
                DLog("read: \(read) total: \(total) expected: \(expected)")
            })
            .responseJSON { response in
                DLog("response:\n\(response)")
                switch response.result {
                case .Success:
                    handleResponse(response.response!)
                    if response.data != nil {
                        DataHandler.sharedInstance.newData(response.data!)
                    }
                case .Failure(let error):
                    let errorMessage: String = error.userInfo["NSDebugDescription"]! as! String
                    DLog("Status Code \(response.response!.statusCode): Error: \(errorMessage)")
                }
        }
    }
    
    /*
     * handleResponse
     *
     * performs actions based on response code
     *
     * @param: response: NSHTTPURLResponse - The response from the request
     */
    class func handleResponse (response: NSHTTPURLResponse) {
        switch response.statusCode {
        case 500:
            DLog("Status Code 500: Server Error")
        default:
            DLog("Status Code \(response.statusCode)")
        }
    }
}
