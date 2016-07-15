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
        if let resultData = jsonData as? NSArray {
            for object in resultData {
                let result: [String: AnyObject] = self.extractValuesFromJSON(object, values: ["item", "owner", "buyout", "bid", "quantity"])
                searchResults.append(result)
            }
        } else {
            DLog("Cannot convert data into array")
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
                DLog("Cannot extract a value for \"\(elementName)\"")
            }
        }
        return result
    }
}
