//
//  DataInterfaceTests.swift
//  AuctionAlert_Swift
//
//  Created by Robin Spinks on 01/06/2017.
//  Copyright © 2017 UglyBlueCat. All rights reserved.
//

import XCTest
@testable import AuctionAlert

class DataInterfaceTests: XCTestCase {
    
    let dataInterface = DataInterface()
    
    func testAuctionArray() {
        var returnedAuctionList : Array<Dictionary<String, Any>> = []
        
        let testAuctionList : Array<Dictionary<String, Any>> = [["item" : 4306, "owner" : "Jim", "buyout" : 10, "bid" : 1, "quantity" : 200], ["item" : 4306, "owner" : "Jim", "buyout" : 10, "bid" : 1, "quantity" : 200], ["item" : 4306, "owner" : "Jim", "buyout" : 10, "bid" : 1, "quantity" : 200]]
        
        do {
            try dataInterface.saveAuctionList(testAuctionList)
        } catch {
            XCTFail("Failed to save auction list: \(error.localizedDescription)")
        }
        
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
    
    func testRealmArray() {
        var returnedRealmList : Array<String> = []
        let testRealmList : Array<String> = ["Hellfire", "Argent Dawn", "Darksorrow"]
        
        do {
            try dataInterface.saveRealmList(testRealmList)
        } catch {
            XCTFail("Failed to save realm list: \(error.localizedDescription)")
        }
        
        do {
            returnedRealmList = try dataInterface.loadRealmList()
        } catch {
            XCTFail("Failed to load realm list: \(error.localizedDescription)")
        }
        
        XCTAssertEqual(testRealmList.count, returnedRealmList.count)
        
        for i in 0..<testRealmList.count {
            XCTAssertEqual(testRealmList[i], returnedRealmList[i])
        }
    }
}
