//
//  DataHandlerTests.swift
//  AuctionAlert_Swift
//
//  Created by Robin Spinks on 23/02/2017.
//  Copyright © 2017 UglyBlueCat. All rights reserved.
//

import XCTest
@testable import AuctionAlert

class DataHandlerTests: XCTestCase {
    
    let dataHandler = DataHandler()
    let dataInterface = DataInterface()

    func testRealmDataStorage() {
        var returnedRealmList : Array<String> = []
        let testRealmList : Array<Dictionary<String, Any>> = [["name": "Hellfire"], ["name": "Argent Dawn"], ["name": "Darksorrow"]]
        
        dataHandler.populateRealmData(testRealmList as NSArray)
        
        do {
            returnedRealmList = try dataInterface.loadRealmList()
        } catch {
            XCTFail("Failed to load realm list: \(error.localizedDescription)")
        }
        
        XCTAssertEqual(testRealmList.count, returnedRealmList.count)
        
        for i in 0..<testRealmList.count {
            if let testRealm = testRealmList[i]["name"] as? String {
                XCTAssertEqual(testRealm, returnedRealmList[i])
            } else {
                XCTFail("Cannot convert \(testRealmList[i]["name"] ?? "testRealmList[\(i)][\"name\"]") to String")
            }
        }
    }
    
    func testAuctionDataStorage() {
        var returnedAuctionList : Array<Dictionary<String, Any>> = []
        
        let testAuctionList : Array<Dictionary<String, Any>> = [["item" : 4306, "owner" : "Jim", "buyout" : 10, "bid" : 1, "quantity" : 200], ["item" : 4306, "owner" : "Jim", "buyout" : 10, "bid" : 1, "quantity" : 200], ["item" : 4306, "owner" : "Jim", "buyout" : 10, "bid" : 1, "quantity" : 200]]
        
        dataHandler.populateSearchResults(testAuctionList as NSArray)
        
        do {
            returnedAuctionList = try dataInterface.loadAuctionList()
        } catch {
            XCTFail("Failed to load auction list: \(error.localizedDescription)")
        }
        
        XCTAssertEqual(testAuctionList.count, returnedAuctionList.count)
        
        for i in 0..<testAuctionList.count {
            for key in testAuctionList[i].keys {
                let testObject = testAuctionList[i][key]
                let returnedObject = returnedAuctionList[i][key]
                
                if testObject is String {
                    XCTAssertEqual(testObject as! String, returnedObject as! String)
                } else if testObject is Int {
                    XCTAssertEqual(testObject as! Int, returnedObject as! Int)
                }
            }
        }
    }
}
