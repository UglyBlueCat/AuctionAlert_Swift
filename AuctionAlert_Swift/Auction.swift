//
//  Auction.swift
//  AuctionAlert_Swift
//
//  Created by Robin Spinks on 29/05/2017.
//  Copyright © 2017 UglyBlueCat. All rights reserved.
//

import Foundation

class Auction {
    
    var item = 0
    var owner = ""
    var buyout = 0
    var bid = 0
    var quantity = 0
    
    init() {}
    
    init(_ dict : Dictionary<String, Any>) {
        self.item = dict["item"] as? Int ?? 0
        self.owner = dict["owner"] as? String ?? ""
        self.buyout = dict["buyout"] as? Int ?? 0
        self.bid = dict["bid"] as? Int ?? 0
        self.quantity = dict["quantity"] as? Int ?? 0
    }
}
