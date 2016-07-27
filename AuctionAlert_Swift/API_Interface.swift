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
     * @param: price:   String - The maximum price
     */
    class func searchAuction (realm: String, object: String, price: String) {
        let params: Dictionary = ["command": "search", "realm": realm, "object_name": object, "price": price]
        getRequest(params, urlString: auctionAlertURL)
    }
    
    /*
     * saveSearch
     *
     * Saves a search for an object in a realm
     * This will result in a push notification if the object is found by the server
     *
     * @param: realm:   String - The realm to search in
     * @param: object:  String - The object to search for
     * @param: price:   String - The maximum price
     */
    class func saveSearch (realm: String, object: String, price: String) {
        let params: Dictionary = ["command": "save", "realm": realm, "object_name": object, "price": price]
        postRequest(params, urlString: auctionAlertURL)
    }
    
    /*
     * listAuctions
     *
     * Initiates an API call to retrieve all saved searches
     */
    class func listAuctions () {
        let params: Dictionary = ["command": "fetch"]
        getRequest(params, urlString: auctionAlertURL)
    }
    
    /*
     * deleteAuction
     *
     * Initiates an API call to delete a saved search
     *
     * @param: realm:   String - The realm to search in
     * @param: object:  String - The object to search for
     * @param: price:   String - The maximum price
     */
    class func deleteAuction (realm: String, object: String, price: String) {
        let params: Dictionary = ["command": "delete", "realm": realm, "object_name": object, "price": price]
        deleteRequest(params, urlString: auctionAlertURL)
    }
    
    /*
     * getRequest
     *
     * Calls a request with the GET method
     *
     * @param: params: Dictionary<String, String> - The parameters for the GET request
     */
    class func getRequest (params: Dictionary<String, String>, urlString: String) {
        makeRequest(.GET, params: params, urlString: urlString)
    }
    
    /*
     * postRequest
     *
     * Calls a request with the POST method
     *
     * @param: params: Dictionary<String, String> - The parameters for the POST request
     */
    class func postRequest (params: Dictionary<String, String>, urlString: String) {
        makeRequest(.POST, params: params, urlString: urlString)
    }
    
    /*
     * deleteRequest
     *
     * Calls a request with the DELETE method
     *
     * @param: params: Dictionary<String, String> - The parameters for the DELETE request
     */
    class func deleteRequest (params: Dictionary<String, String>, urlString: String) {
        makeRequest(.DELETE, params: params, urlString: urlString)
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
            .validate(statusCode: 200..<600)
            .progress({ (read, total, expected) in
                DLog("read: \(read) total: \(total) expected: \(expected)")
            })
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if response.data != nil {
                        DataHandler.sharedInstance.newData(response.data!)
                    }
                    handleResponse(response.response!)
                case .Failure(let error):
                    DLog("Status Code \(response.response!.statusCode): Error: \(error.localizedDescription)")
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
        case 200:
            return
        case 500:
            DLog("Status Code 500: Server Error")
        default:
            DLog("Status Code \(response.statusCode)")
        }
    }
}
