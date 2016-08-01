//
//  API_Interface.swift
//  AuctionAlert_Swift
//
//  Created by Robin Spinks on 12/07/2016.
//  Copyright © 2016 UglyBlueCat. All rights reserved.
//

import Foundation
import Alamofire

let locale: String? = userDefaults.stringForKey(localeKey)
let deviceID: String? = userDefaults.stringForKey(deviceKey)
let genericAAParams : Dictionary = ["locale": locale ?? "",
                                    "idforvendor": idForVendor ?? "",
                                    "deviceid": deviceID ?? ""]

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
    class func searchAuction (object: String, price: String) {
        var params: Dictionary = ["command": "search",
                                  "realm": userDefaults.stringForKey(realmKey) ?? "",
                                  "object_name": object,
                                  "price": price]
        for key in genericAAParams.keys {
            params.updateValue(genericAAParams[key]!, forKey: key)
        }
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
    class func saveSearch (object: String, price: String) {
        var params: Dictionary = ["command": "save",
                                  "realm": userDefaults.stringForKey(realmKey) ?? "",
                                  "object_name": object,
                                  "price": price]
        for key in genericAAParams.keys {
            params.updateValue(genericAAParams[key]!, forKey: key)
        }
        postRequest(params, urlString: auctionAlertURL)
    }
    
    /*
     * listAuctions
     *
     * Initiates an API call to retrieve all saved searches
     */
    class func listAuctions () {
        var params: Dictionary = ["command": "fetch"]
        for key in genericAAParams.keys {
            params.updateValue(genericAAParams[key]!, forKey: key)
        }
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
    class func deleteAuction (object: String, price: String) {
        var params: Dictionary = ["command": "delete",
                                  "realm": userDefaults.stringForKey(realmKey) ?? "",
                                  "object_name": object,
                                  "price": price]
        for key in genericAAParams.keys {
            params.updateValue(genericAAParams[key]!, forKey: key)
        }
        deleteRequest(params, urlString: auctionAlertURL)
    }
    
    /*
     * fetchRealmData
     *
     * retrieves realm data from the battle.net server for the current region
     */
    class func fetchRealmData () {
        let locale : String = userDefaults.stringForKey(localeKey) ?? ""
        let region : String = userDefaults.stringForKey(regionKey) ?? ""
        let params: Dictionary = ["locale": locale, "apikey": battleAPIKey]
        let battleURL : String = "https://\(battleHost[region] ?? "")/wow/realm/status"
        DLog("battleURL: \(battleURL)")
        getRequest(params, urlString: battleURL)
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
        
        Alamofire.request(method, urlString, parameters: params)
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
                    DLog("Status Code \(response.response?.statusCode ?? -999): Error: \(error.localizedDescription)")
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
