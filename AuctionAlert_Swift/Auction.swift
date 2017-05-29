//
//  Auction.swift
//  AuctionAlert_Swift
//
//  Created by Robin Spinks on 29/05/2017.
//  Copyright © 2017 UglyBlueCat. All rights reserved.
//

import Foundation

class Auction {
    
    var item = ""
    var owner = ""
    var buyout = ""
    var bid = ""
    var quantity = ""
    var message = ""
    var code = ""
    var locale = ""
    var object = ""
    var price = ""
    var realm = ""
    
    init() {}
    
    init(_ dict : Dictionary<String, String>) {
        self.item = dict["item"] ?? ""
        self.owner = dict["owner"] ?? ""
        self.buyout = dict["buyout"] ?? ""
        self.bid = dict["bid"] ?? ""
        self.quantity = dict["quantity"] ?? ""
        self.message = dict["itmessageem"] ?? ""
        self.code = dict["code"] ?? ""
        self.locale = dict["locale"] ?? ""
        self.object = dict["object"] ?? ""
        self.price = dict["price"] ?? ""
        self.realm = dict["realm"] ?? ""
    }
}
