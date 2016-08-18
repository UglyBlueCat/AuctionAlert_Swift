//
//  DataHandler.swift
//  AuctionAlert_Swift
//
//  Created by Robin Spinks on 14/07/2016.
//  Copyright © 2016 UglyBlueCat. All rights reserved.
//

import Foundation

class DataHandler {
    var searchResults: Array<Dictionary<String, AnyObject>> = Array()
    var realmList: Array<String> = Array()
    
    static let sharedInstance = DataHandler()
    private init() {}
    
    /*
     * newData
     *
     * Converts a raw data object to JSON, which is then passed to populateResults
     *
     * @param: newData: NSData - The raw data
     */
    func newData (newData: NSData) {
        do {
            let jsonData = try NSJSONSerialization.JSONObjectWithData(newData, options: .MutableLeaves)
            self.populateResults(jsonData)
        } catch {
            DLog("JSON conversion error: \(error)")
        }
    }
    
    /*
     * populateResults
     *
     * Separates a JSON Array into JSON Dictionary objects
     * Passes each object through extractValuesFromJSON before adding to searchResults property
     *
     * @param: jsonData: AnyObject
     */
    func populateResults (jsonData: AnyObject) {
        if let resultData = jsonData as? NSDictionary {
            if let realmData = resultData["realms"] as? NSArray { // It'll be realm data from battle.net
                realmList.removeAll()
                for object in realmData {
                    if let realmName = object["name"] as? String {
                        realmList.append(realmName)
                    }
                }
                NSNotificationCenter.defaultCenter().postNotificationName("kRealmsReceived", object: nil)
            } else if let message = resultData["message"] as? String { // It'll be an API response message
                NSNotificationCenter.defaultCenter().postNotificationName("kMessageReceived",
                                                                          object: nil,
                                                                          userInfo: ["message" : message])
            } else if let iconImage = resultData["icon"] as? String { // It'll be item data from Blizzard
                if let itemID = resultData["id"] as? Int {
                    ImageFetcher.sharedInstance.downloadImage(String(itemID), name: iconImage)
                }
            } else if let code = resultData["code"] as? Int { // It'll be a code check result
                API_Interface.sharedInstance.fetchObjectData(String(code))
            }
        } else if let resultData = jsonData as? NSArray { // It'll be search results from the AuctionAlert API
            searchResults.removeAll()
            for object in resultData {
                let result: [String: AnyObject] = self.extractValuesFromJSON(object, values: ["item", "owner", "buyout", "bid", "quantity", "message", "code", "locale", "object", "price", "realm"])
                searchResults.append(result)
            }
            NSNotificationCenter.defaultCenter().postNotificationName("kDataReceived", object: nil)
        } else if let message = jsonData["message"] as? String { // It'll be an API response message
            NSNotificationCenter.defaultCenter().postNotificationName("kMessageReceived",
                                                                      object: nil,
                                                                      userInfo: ["message" : message])
        } else {
            DLog("Cannot convert data")
        }
    }
    
    /*
     * extractValuesFromJSON
     *
     * Extracts key/value pairs from a JSON Dictionary and returns them in a Dictionary
     *
     * @param: object: AnyObject        - The JSON dictionary
     * @param: values: Array<String>    - The keys to extract with their values
     *
     * @returns: Dictionary<String, AnyObject> - A swift Dictionary containing the key/value pairs extracted
     */
    func extractValuesFromJSON (object: AnyObject, values: Array<String>) -> Dictionary<String, AnyObject> {
        var result: [String: AnyObject] = [:]
        for elementName in values {
            if let itemStr = object[elementName] as? String {
                result.updateValue(itemStr, forKey: elementName)
            } else if let itemInt = object[elementName] as? Int {
                result.updateValue(itemInt, forKey: elementName)
            } else {
                // Assume element doesn't exist
            }
        }
        if result.count < 1 {
            DLog("No values extracted from object:\n\(object)")
        }
        return result
    }
}
