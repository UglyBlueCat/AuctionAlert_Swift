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
    
    func saveAuctionList(_ auctionList : Array<Dictionary<String, Any>>, completion : (() throws -> Void)? = nil) throws {
        
        var auctionFileHandler : FileHandler = FileHandler()
        var jsonData : Data = Data()
        
        do {
            auctionFileHandler = try FileHandler(fileName: "Auctions")
            jsonData = try JSONSerialization.data(withJSONObject: auctionList)
            try auctionFileHandler.write(jsonData)
        } catch FileHandler.FileHandlerError.writeError(let desc) {
            DLog("FileHandlerError.writeError occured: \(desc)")
            DLog("Deleting & trying once more...")
            try auctionFileHandler.delete() { () in
                try auctionFileHandler.write(jsonData)
            }
        } catch {
            throw error
        }
        
        do {
            try completion?()
        } catch {
            throw error
        }
    }
    
    func loadAuctionList() throws -> Array<Dictionary<String, Any>> {
        
        var auctionFileHandler : FileHandler = FileHandler()
        var auctionList : Array<Dictionary<String, Any>> = []
        var auctionData : Data = Data()
        
        do {
            auctionFileHandler = try FileHandler(fileName: "Auctions")
            auctionData = try auctionFileHandler.read()
            auctionList = try JSONSerialization.jsonObject(with: auctionData) as! Array<Dictionary<String, Any>>
        } catch {
            throw error
        }
        
        return auctionList
    }
    
    func saveRealmList(_ realmList : Array<String>, completion : (() throws -> Void)? = nil) throws {
        
        var realmFileHandler : FileHandler = FileHandler()
        var jsonData : Data = Data()
        
        do {
            realmFileHandler = try FileHandler(fileName: "Realms")
            jsonData = try JSONSerialization.data(withJSONObject: realmList)
            try realmFileHandler.write(jsonData)
        } catch FileHandler.FileHandlerError.writeError(let desc) {
            DLog("FileHandlerError.writeError occured: \(desc)")
            DLog("Deleting & trying once more...")
            try realmFileHandler.delete() { () in
                try realmFileHandler.write(jsonData)
            }
        } catch {
            throw error
        }
        
        do {
            try completion?()
        } catch {
            throw error
        }
    }
    
    func loadRealmList() throws -> Array<String> {
        
        var realmFileHandler : FileHandler = FileHandler()
        var realmList : Array<String> = []
        var realmData : Data = Data()
        
        do {
            realmFileHandler = try FileHandler(fileName: "Realms")
            realmData = try realmFileHandler.read()
            realmList = try JSONSerialization.jsonObject(with: realmData) as! Array<String>
        } catch {
            throw error
        }
        
        return realmList
    }
}
