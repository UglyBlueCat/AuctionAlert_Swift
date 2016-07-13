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
        print("\(#function) Searching for \(object) on \(realm)")
        
        let baseURL: String = "http://uglybluecat.com/AuctionAlert.php"
        let params: Dictionary = ["command": "search", "realm": realm, "object_name": object]
        
        Alamofire.request(.GET, baseURL, parameters: params)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .Success:
                    print("\(#function) Validation Successful")
                    print("\(#function) Response:\n\(response)")
                case .Failure(let error):
                    print("\(#function) Error: \(error)")
                }
        }
    }
}
