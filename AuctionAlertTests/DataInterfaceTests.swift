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
    
    let testAuctionList : Array<Dictionary<String, String>> = [["item" : "4306", "owner" : "Jim", "buyout" : "10", "bid" : "1", "quantity" : "200"], ["item" : "4306", "owner" : "Jim", "buyout" : "10", "bid" : "1", "quantity" : "200"], ["item" : "4306", "owner" : "Jim", "buyout" : "10", "bid" : "1", "quantity" : "200"]]
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAuctionArray() {
        var returnedAuctionList : Array<Dictionary<String, String>> = []
        
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
                XCTAssertEqual(testAuctionList[i][key], returnedAuctionList[i][key])
            }
        }
    }
}
