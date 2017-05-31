//
//  FileHandler.swift
//  AuctionAlert_Swift
//
//  Created by Robin Spinks on 29/05/2017.
//  Copyright © 2017 Robin Spinks. All rights reserved.
//

import Foundation

class FileHandler {
    var fileURL : URL
    
    init() {
        fileURL = URL(string: "")!
        createFile() // Want to throw error
    }
    
    private func createFile() {
        let fileNamed = "AuctionAlert"
        let folder = "AuctionAlert"
        
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            DLog("Cannot establish path") // Want to throw error
            return
        }
        
        guard let writePath = NSURL(fileURLWithPath: path).appendingPathComponent(folder) else {
            DLog("Cannot create folder \(folder)") // Want to throw error
            return
        }
        
        do {
            try FileManager.default.createDirectory(atPath: writePath.path, withIntermediateDirectories: true)
        } catch {
            DLog("Error: \(error) creating file at path: \(path)") // Want to throw error
            return
        }
        
        fileURL = writePath.appendingPathComponent(fileNamed + ".txt")
    }
    
    func write(_ text : String) {
        do {
            try text.write(to: fileURL, atomically: false, encoding: String.Encoding.utf8)
        } catch {
            DLog("Error: \(error) writing to file at path: \(fileURL)") // Want to throw error
        }
    }
    
    func read() {
        
    }
}
