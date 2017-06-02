//
//  DataInterface.swift
//  AuctionAlert_Swift
//
//  Created by Robin Spinks on 01/06/2017.
//  Copyright © 2017 UglyBlueCat. All rights reserved.
//

import Foundation

class DataInterface {
    
    init() {}
    
    func saveAuctionList(_ auctionList : Array<Dictionary<String, String>>) throws {
        
        var auctionFileHandler : FileHandler = FileHandler()
        var jsonData : Data = Data()
        
        do {
            auctionFileHandler = try FileHandler(fileName: "Auctions")
            jsonData = try JSONSerialization.data(withJSONObject: auctionList)
            try auctionFileHandler.write(jsonData)
        } catch FileHandler.FileHandlerError.writeError(let desc) {
            DLog("FileHandlerError.writeError occured: \(desc)")
            DLog("Deleting & trying once more...")
            do {
                try auctionFileHandler.delete() { (success) in
                    try auctionFileHandler.write(jsonData)
                }
            } catch {
                throw error
            }
        } catch {
            throw error
        }
    }
    
    func loadAuctionList() throws -> Array<Dictionary<String, String>> {
        
        var auctionFileHandler : FileHandler = FileHandler()
        var auctionList : Array<Dictionary<String, String>> = []
        var auctionData : Data = Data()
        
        do {
            auctionFileHandler = try FileHandler(fileName: "Auctions")
            auctionData = try auctionFileHandler.read()
            auctionList = try JSONSerialization.jsonObject(with: auctionData) as! Array<Dictionary<String, String>>
        } catch {
            throw error
        }
        
        return auctionList
    }
}
