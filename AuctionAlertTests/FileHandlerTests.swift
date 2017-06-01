//
//  FileHandlerTests.swift
//  AuctionAlert_Swift
//
//  Created by Robin Spinks on 31/05/2017.
//  Copyright © 2017 UglyBlueCat. All rights reserved.
//

import XCTest
@testable import AuctionAlert

class FileHandlerTests: XCTestCase {
    var testFile : FileHandler = FileHandler()
    
    override func setUp() {
        super.setUp()
        
        do {
            try testFile = FileHandler(fileName: "testFile")
        } catch {
            XCTFail("Failed file URL creation: \(error.localizedDescription)")
        }
    }
    
    override func tearDown() {
        super.tearDown()
        
        do {
            try testFile.delete()
        } catch {
            XCTFail("Failed to delete file: \(error.localizedDescription)")
        }
    }
    
    func testWriteAndRead() {
        let testDict : Dictionary<String, Any> = ["array":[1,2,3], "boolean":true, "number":123, "object":["a":"b","c":"d","e":"f"], "string":"Hello World"]
        var testData : Data = Data()
        var readData : Data = Data()
        
        do {
            testData = try JSONSerialization.data(withJSONObject: testDict)
        } catch {
            XCTFail("Failed to convert testDict to JSON data: \(error)")
        }
        
        do {
            try testFile.write(testData)
        } catch {
            XCTFail("Failed to write to file: \(error.localizedDescription)")
        }
        
        do {
            readData = try testFile.read()
        } catch {
            XCTFail("Failed to read from file: \(error.localizedDescription)")
        }
        
        XCTAssertEqual(testData, readData)
    }
}
