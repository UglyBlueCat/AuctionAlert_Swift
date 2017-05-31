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
        let testString = "{\"array\":[1,2,3],\"boolean\":true,\"null\":null,\"number\":123,\"object\":{\"a\":\"b\",\"c\":\"d\",\"e\":\"f\"},\"string\":\"Hello World\"}"
        var readString : String = ""
        
        do {
            try testFile.write(testString)
        } catch {
            XCTFail("Failed to write to file: \(error.localizedDescription)")
        }
        
        do {
            readString = try testFile.read()
        } catch {
            XCTFail("Failed to read from file: \(error.localizedDescription)")
        }
        
        XCTAssertEqual(testString, readString)
    }
}
