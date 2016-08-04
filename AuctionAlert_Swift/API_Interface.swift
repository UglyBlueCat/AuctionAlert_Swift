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
    
    let alamofireManager : Alamofire.Manager?
    
    static let sharedInstance = API_Interface()
    private init() {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForRequest = 300.0
        alamofireManager = Alamofire.Manager(configuration: configuration)
    }
    
    /*
     * searchAuction
     *
     * Initiates a search API call for an object in a realm
     *
     * @param: realm:   String - The realm to search in
     * @param: object:  String - The object to search for
     * @param: price:   String - The maximum price
     */
    func searchAuction (object: String, price: String) {
        var params: Dictionary<String, AnyObject> = ["command": "search",
                                                     "realm": userDefaults.stringForKey(realmKey) ?? "",
                                                     "object_name": object,
                                                     "price": price]
        params = addGlobalValues(params)
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
    func saveSearch (object: String, price: String) {
        var params: Dictionary<String, AnyObject> = ["command": "save",
                                                     "realm": userDefaults.stringForKey(realmKey) ?? "",
                                                     "object_name": object,
                                                     "price": price]
        params = addGlobalValues(params)
        postRequest(params, urlString: auctionAlertURL)
    }
    
    /*
     * listAuctions
     *
     * Initiates an API call to retrieve all saved searches
     */
    func listAuctions () {
        var params: Dictionary<String, AnyObject> = ["command": "fetch"]
        params = addGlobalValues(params)
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
    func deleteAuction (object: String, price: String) {
        var params: Dictionary<String, AnyObject> = ["command": "delete",
                                                     "realm": userDefaults.stringForKey(realmKey) ?? "",
                                                     "object_name": object,
                                                     "price": price]
        params = addGlobalValues(params)
        deleteRequest(params, urlString: auctionAlertURL)
    }
    
    
    /*
     * checkCode
     *
     * validates an entered object name by retrieving its code from the API
     *
     * @param: object:  String - The object to check
     */
    func checkCode (object: String) {
        var params: Dictionary<String, AnyObject> = ["command": "code",
                                                     "object_name": object]
        params = addGlobalValues(params)
        getRequest(params, urlString: auctionAlertURL)
    }
    
    /*
     * fetchRealmData
     *
     * retrieves realm data from the battle.net server for the current region
     */
    func fetchRealmData () {
        if let
            locale : String = userDefaults.stringForKey(localeKey),
            region : String = userDefaults.stringForKey(regionKey),
            localBattleHost : String = battleHost[region]
        {
            let params: Dictionary<String, AnyObject> = ["locale": locale, "apikey": battleAPIKey]
            let battleURL : String = "https://\(localBattleHost)/wow/realm/status"
            DLog("battleURL: \(battleURL)")
            getRequest(params, urlString: battleURL)
        }
    }
    
    /*
     * getRequest
     *
     * Calls a request with the GET method
     *
     * @param: params: Dictionary<String, String> - The parameters for the GET request
     */
    func getRequest (params: Dictionary<String, AnyObject>, urlString: String) {
        makeRequest(.GET, params: params, urlString: urlString)
    }
    
    /*
     * postRequest
     *
     * Calls a request with the POST method
     *
     * @param: params: Dictionary<String, String> - The parameters for the POST request
     */
    func postRequest (params: Dictionary<String, AnyObject>, urlString: String) {
        makeRequest(.POST, params: params, urlString: urlString)
    }
    
    /*
     * deleteRequest
     *
     * Calls a request with the DELETE method
     *
     * @param: params: Dictionary<String, String> - The parameters for the DELETE request
     */
    func deleteRequest (params: Dictionary<String, AnyObject>, urlString: String) {
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
    func makeRequest (method: Alamofire.Method, params: Dictionary<String, AnyObject>, urlString: String) {
        
        alamofireManager!.request(method, urlString, parameters: params)
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
                    self.handleResponse(response.response!)
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
    func handleResponse (response: NSHTTPURLResponse) {
        switch response.statusCode {
        case 200:
            return
        case 500:
            DLog("Status Code 500: Server Error")
        default:
            DLog("Status Code \(response.statusCode)")
        }
    }
    
    /*
     * addGlobalValues
     *
     * Adds global values to a parameter set
     *
     * @param: Dictionary<String, AnyObject>  - a set of parameters specific to a request
     * @return: Dictionary<String, AnyObject> - the same parameters updated with additional genereric values
     */
    func addGlobalValues (params: Dictionary<String, AnyObject>) -> Dictionary<String, AnyObject> {
        var localParams: Dictionary<String, AnyObject> = params
        
        if let locale: String = userDefaults.stringForKey(localeKey) {
            localParams.updateValue(locale, forKey: "locale")
        }
        
        if let deviceID: String = userDefaults.stringForKey(deviceKey) {
            localParams.updateValue(deviceID, forKey: "deviceid")
        }
        
        if let localIDforVendor: String = idForVendor {
            localParams.updateValue(localIDforVendor, forKey: "idforvendor")
        }
        
        return localParams
    }
}
