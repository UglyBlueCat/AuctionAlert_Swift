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
    
    init() {}
    
    /**
     Converts a raw data object to JSON, which is then passed to populateResults
     
     - parameter newData: The raw data
     */
    func newData (newData: Data) {
        do {
            let jsonData = try JSONSerialization.jsonObject(with: newData, options: .mutableLeaves)
            self.populateResults(jsonData: jsonData as AnyObject)
        } catch {
            DLog("JSON conversion error: \(error)")
        }
    }
    
    /**
     Separates a JSON Array into JSON Dictionary objects.
     
     - parameter jsonData: The JSON Array
     */
    func populateResults (jsonData: AnyObject) {
        if let resultData = jsonData as? NSDictionary {
            if let realmData = resultData["realms"] as? NSArray {
                self.populateRealmData(realmData: realmData)
            } else if let message = resultData["message"] as? String {
                self.handleMessage(message: message)
            } else if let iconImage = resultData["icon"] as? String {
                self.populateItemData(iconImage: iconImage, resultData: resultData)
            } else if let code = resultData["code"] as? Int {
                self.handleCodeCheckResult(code: code)
            }
        } else if let resultData = jsonData as? NSArray {
            self.populateSearchResults(resultData: resultData)
        } else if let message = jsonData["message"] as? String {
            self.handleMessage(message: message)
        } else {
            DLog("Cannot convert data")
        }
    }
    
    /**
     Initiates download of an objects item data from Blizzard and notifies the system that the code was OK
     
     - parameter code: The code that was checked
     */
    func handleCodeCheckResult (code: Int) {
        API_Interface.sharedInstance.fetchObjectData(code: String(code))
        NotificationCenter.default.post(name: Notification.Name(rawValue: "kCodeOK"), object: nil)
    }
    
    /**
     Downloads the icon for an item after that items data is received from Blizzard
     
     - parameters:
        - iconImage: The name of the icon image
        - resultData: The data containing the id for the image
     */
    func populateItemData (iconImage: String, resultData: NSDictionary) {
        if let itemID = resultData["id"] as? Int {
            ImageFetcher.sharedInstance.downloadImage(code: String(itemID), name: iconImage)
        }
    }
    
    /**
     Notifies the system that a response message was received from the API
     
     - parameter message: The message
     */
    func handleMessage (message: String) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "kMessageReceived"),
                                        object: nil,
                                        userInfo: ["message" : message])
    }
    
    /**
     Populates the realm list with data from battle.net
     
     - parameter realmData: The list of realms
     */
    func populateRealmData (realmData: NSArray) {
        realmList.removeAll()
        for object in realmData {
            if let dictionaryObject = object as? NSDictionary,
                let realmName = dictionaryObject["name"] as? String
            {
                realmList.append(realmName)
            }
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "kRealmsReceived"), object: nil)
    }
    
    
    /**
     Populates search results from the AuctionAlert API
     
     - parameter resultData: The search results
     */
    func populateSearchResults (resultData: NSArray) {
        searchResults.removeAll()
        for object in resultData {
            let result: [String: AnyObject] = self.extractValuesFromJSON(object: object as AnyObject, values: ["item", "owner", "buyout", "bid", "quantity", "message", "code", "locale", "object", "price", "realm"])
            searchResults.append(result)
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "kDataReceived"), object: nil)
    }
    
    /**
     Extracts key/value pairs from a JSON Dictionary and returns them in a Dictionary
     
     - parameters:
        - object: The JSON dictionary
        - values: The keys to extract with their values
     
     - returns: The key/value pairs extracted
     */
    func extractValuesFromJSON (object: AnyObject, values: Array<String>) -> Dictionary<String, AnyObject> {
        var result: [String: AnyObject] = [:]
        for elementName in values {
            if let itemStr = object[elementName] as? String {
                result.updateValue(itemStr as AnyObject, forKey: elementName)
            } else if let itemInt = object[elementName] as? Int {
                result.updateValue(itemInt as AnyObject, forKey: elementName)
            } else {
                DLog("Element \(elementName) doesn't exist")
            }
        }
        if result.count < 1 {
            DLog("No values extracted from object:\n\(object)")
        }
        return result
    }
}
