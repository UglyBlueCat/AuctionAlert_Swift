//
//  NetworkManagerTests.swift
//  AuctionAlert_Swift
//
//  Created by Robin Spinks on 13/02/2017.
//  Copyright © 2017 UglyBlueCat. All rights reserved.
//

import XCTest
@testable import AuctionAlert

class NetworkManagerTests: XCTestCase {
    
    var networkManager: NetworkManager!
    
    override func setUp() {
        super.setUp()
        DLog("")
        networkManager = NetworkManager.sharedInstance
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInstanceNotNil() {
        XCTAssertNotNil(networkManager)
    }
    
    func testInstanceUnique() {
        let testValue : Int = 1
        
        // Create another NetworkManager that should be the same shared instance
        let networkManager2: NetworkManager! = NetworkManager.sharedInstance
        
        // Test that the default sessions of each instance are equal 
        // according to the isEqual method of URLSession
        XCTAssertEqual(networkManager.defaultSession, networkManager2.defaultSession)
        XCTAssertTrue(networkManager2.defaultSession.isEqual(networkManager.defaultSession))
        
        networkManager.testVariable = testValue
        
        XCTAssertEqual(networkManager2.testVariable, testValue)
    }
    
    // This test requires a response from the API
    func testRequestHandling() {
        let expect = expectation(description: "waitForNetworkManager")
        
        var testData : Data = Data()
        
        makeRequest { (data, urlResponse, error) in
            guard error == nil else {
                XCTFail("error: \(error!.localizedDescription)")
                return
            }
            guard data != nil else {
                XCTFail("data == nil")
                return
            }
            testData = data!
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssert(testData.count > 0)
    }
    
    // A version of API_Interface.makeRequest hard coded to perform an item code check		
    func makeRequest (completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var params: Dictionary<String, AnyObject> = ["command": "code" as AnyObject,
                                                     "object_name": "silk cloth" as AnyObject]
        params = API_Interface.sharedInstance.addGlobalValues(params: params)
        
        if var urlComponents = URLComponents(string: auctionAlertURL) {
            
            var requestParams: [URLQueryItem] = []
            
            for (paramName, paramValue) in params {
                requestParams.append(URLQueryItem(name: paramName, value: paramValue as? String))
            }
            
            urlComponents.queryItems = requestParams
            
            if let url : URL = urlComponents.url {
                var request : URLRequest = URLRequest(url: url)
                request.httpMethod = "GET"
                networkManager.handleRequest(request: request, completion: completion)
            }
        }
    }
    
}
