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
    
    var dataHandler : DataHandler!
    
    override func setUp() {
        super.setUp()
        dataHandler = DataHandler.sharedInstance
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInstanceNotNull() {
        XCTAssertNotNil(dataHandler)
    }
    
    func testOnlySingleInstance() {
        let testRealmArray: Array<String> = ["hellfire", "argent dawn"]
        let secondDataHandler : DataHandler! = DataHandler.sharedInstance
        dataHandler.realmList = testRealmArray
        XCTAssertEqual(secondDataHandler.realmList, testRealmArray)
    }
}
