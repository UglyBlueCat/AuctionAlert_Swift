//
//  FileHandler.swift
//  AuctionAlert_Swift
//
//  Created by Robin Spinks on 29/05/2017.
//  Copyright © 2017 Robin Spinks. All rights reserved.
//

import Foundation

class FileHandler {
    
    enum FileHandlerError: Error {
        case findPathError
        case appendFolderError(folder : String)
    }
    
    var fileURL : URL!
    
    init() {}
    
    init(fileName : String) throws {
        do {
            try createFileURL(fileName)
        } catch {
            throw error
        }
    }
    
    private func createFileURL(_ fileName : String) throws {
        let folder = "AuctionAlert"
        
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            throw FileHandlerError.findPathError
        }
        
        guard let writePath = NSURL(fileURLWithPath: path).appendingPathComponent(folder) else {
            throw FileHandlerError.appendFolderError(folder: folder)
        }
        
        do {
            try FileManager.default.createDirectory(atPath: writePath.path, withIntermediateDirectories: true)
        } catch {
            throw error
        }
        
        fileURL = writePath.appendingPathComponent(fileName)
    }
    
    func write(_ data : Data) throws {
        do {
            try data.write(to: fileURL)
        } catch {
            throw error
        }
    }
    
    func read() throws -> Data {
        var readData : Data
        
        do {
            readData = try Data(contentsOf: fileURL)
        } catch {
            throw error
        }
        
        return readData
    }
    
    func delete() throws {
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            throw error
        }
    }
}
