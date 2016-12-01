//
//  API_Interface.swift
//  AuctionAlert_Swift
//
//  Created by Robin Spinks on 12/07/2016.
//  Copyright © 2016 UglyBlueCat. All rights reserved.
//

import Foundation

class API_Interface {
    
    enum Method: String {
        case GET, POST, PUT, DELETE
    }
    
    let urlSession : URLSession
    
    static let sharedInstance = API_Interface()
    
    fileprivate init() {
        urlSession = NetworkManager.sharedInstance.defaultSession
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
        var params: Dictionary<String, AnyObject> = ["command": "search" as AnyObject,
                                                     "realm": userDefaults.string(forKey: realmKey) as AnyObject? ?? "" as AnyObject,
                                                     "object_name": object as AnyObject,
                                                     "price": price as AnyObject]
        params = addGlobalValues(params: params)
        getRequest(params: params, urlString: auctionAlertURL)
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
        var params: Dictionary<String, AnyObject> = ["command": "save" as AnyObject,
                                                     "realm": userDefaults.string(forKey: realmKey) as AnyObject,
                                                     "object_name": object as AnyObject,
                                                     "price": price as AnyObject]
        params = addGlobalValues(params: params)
        postRequest(params: params, urlString: auctionAlertURL)
    }
    
    /*
     * listAuctions
     *
     * Initiates an API call to retrieve all saved searches
     */
    func listAuctions () {
        var params: Dictionary<String, AnyObject> = ["command": "fetch" as AnyObject]
        params = addGlobalValues(params: params)
        getRequest(params: params, urlString: auctionAlertURL)
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
        var params: Dictionary<String, AnyObject> = ["command": "delete" as AnyObject,
                                                     "realm": userDefaults.string(forKey: realmKey) as AnyObject,
                                                     "object_name": object as AnyObject,
                                                     "price": price as AnyObject]
        params = addGlobalValues(params: params)
        deleteRequest(params: params, urlString: auctionAlertURL)
    }
    
    
    /*
     * checkCode
     *
     * validates an entered object name by retrieving its code from the API
     *
     * @param: object:  String - The object to check
     */
    func checkCode (object: String) {
        var params: Dictionary<String, AnyObject> = ["command": "code" as AnyObject,
                                                     "object_name": object as AnyObject]
        params = addGlobalValues(params: params)
        getRequest(params: params, urlString: auctionAlertURL)
    }
    
    /*
     * fetchRealmData
     *
     * retrieves realm data from the battle.net server for the current region
     */
    func fetchRealmData () {
        if let
            locale : String = userDefaults.string(forKey: localeKey),
            let region : String = userDefaults.string(forKey: regionKey),
            let localBattleHost : String = battleHost[region]
        {
            let params: Dictionary<String, AnyObject> = ["locale": locale as AnyObject, "apikey": battleAPIKey as AnyObject]
            let battleURL : String = "https://\(localBattleHost)/wow/realm/status"
            getRequest(params: params, urlString: battleURL)
        }
    }
    
    /*
     * fetchObjectData
     *
     * retrieves the data for an object from the battle.net API
     *
     * @param: - The object code
     */
    func fetchObjectData (code: String) {
        if let
            locale : String = userDefaults.string(forKey: localeKey),
            let region : String = userDefaults.string(forKey: regionKey),
            let localBattleHost : String = battleHost[region]
        {
            let params: Dictionary<String, AnyObject> = ["locale": locale as AnyObject, "apikey": battleAPIKey as AnyObject]
            let battleURL : String = "https://\(localBattleHost)/wow/item/\(code)"
            getRequest(params: params, urlString: battleURL)
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
        makeRequest(method: .GET, params: params, urlString: urlString)
    }
    
    /*
     * postRequest
     *
     * Calls a request with the POST method
     *
     * @param: params: Dictionary<String, String> - The parameters for the POST request
     */
    func postRequest (params: Dictionary<String, AnyObject>, urlString: String) {
        makeRequest(method: .POST, params: params, urlString: urlString)
    }
    
    /*
     * deleteRequest
     *
     * Calls a request with the DELETE method
     *
     * @param: params: Dictionary<String, String> - The parameters for the DELETE request
     */
    func deleteRequest (params: Dictionary<String, AnyObject>, urlString: String) {
        makeRequest(method: .DELETE, params: params, urlString: urlString)
    }
    
    /*
     * makeRequest
     *
     * Makes an HTTP request with the provided parameters
     *
     * @param: method: Method                       - The method for the request
     * @param: params: Dictionary<String, String>   - The parameters for the request
     */
    func makeRequest (method: Method, params: Dictionary<String, AnyObject>, urlString: String) {
        
        if var urlComponents = URLComponents(string: urlString) {
            
            var requestParams: [URLQueryItem] = []
            
            for (paramName, paramValue) in params {
                requestParams.append(URLQueryItem(name: paramName, value: paramValue as? String))
            }
            
            urlComponents.queryItems = requestParams
            
            if let url : URL = urlComponents.url {
                var request : URLRequest = URLRequest(url: url)
                request.httpMethod = method.rawValue
                NetworkManager.sharedInstance.handleRequest(request: request) { (data, urlResponse, error) in
                    guard error == nil else {
                        DLog("Error: \(error)")
                        return
                    }
                    DataHandler.sharedInstance.newData(newData: data!)
                }
            } else {
                DLog("Could not obtain NSURL from \(urlComponents.debugDescription)")
            }
        } else {
            DLog("Could not construct NSURLComponents from \(urlString)")
        }
    }
    
    /*
     * handleResponse
     *
     * performs actions based on response code
     *
     * @param: response: NSHTTPURLResponse - The response from the request
     */
    func handleResponse (response: HTTPURLResponse) {
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
        
        if let locale: String = userDefaults.string(forKey: localeKey) {
            localParams.updateValue(locale as AnyObject, forKey: "locale")
        }
        
        if let deviceID: String = userDefaults.string(forKey: deviceKey) {
            localParams.updateValue(deviceID as AnyObject, forKey: "deviceid")
        }
        
        if let localIDforVendor: String = idForVendor {
            localParams.updateValue(localIDforVendor as AnyObject, forKey: "idforvendor")
        }
        
        return localParams
    }
}
