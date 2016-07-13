//
//  API_Interface.swift
//  AuctionAlert_Swift
//
//  Created by Robin Spinks on 12/07/2016.
//  Copyright © 2016 UglyBlueCat. All rights reserved.
//

import Foundation
import Alamofire

class API_Interface {
    
    class func searchAuction (realm: String, object: String) {
        print("[\(#function)] Searching for \(object) on \(realm)")
        let params: Dictionary = ["command": "search", "realm": realm, "object_name": object]
        self.getRequest(params)
    }
    
    class func getRequest (params: Dictionary<String, String>) {
        print("[\(#function)] Parameters: \(params)")
        self.makeRequest(.GET, params: params)
    }
    
    class func makeRequest (method: Alamofire.Method, params: Dictionary<String, String>) {
        print("[\(#function)] Method: \(method) Parameters: \(params)")
        let baseURL: String = "http://uglybluecat.com/AuctionAlert.php"
        
        Alamofire.request(method, baseURL, parameters: params)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .Success:
                    print("[\(#function)] Validation Successful")
                    print("[\(#function)] Response:\n\(response)")
                case .Failure(let error):
                    print("[\(#function)] Error: \(error)")
                }
        }
    }
}
