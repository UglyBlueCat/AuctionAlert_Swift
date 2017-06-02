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
        case appendFolderError(_ : String)
        case writeError(_ : String)
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
    
    /**
     Creates a URL for a file and assigns it to the global variable fileURL
     
     - parameters:
         - fileName: The name of the file
     
     - throws: An error describing what went wrong
     */
    private func createFileURL(_ fileName : String) throws {
        let folder = "AuctionAlert"
        
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            throw FileHandlerError.findPathError
        }
        
        guard let writePath = NSURL(fileURLWithPath: path).appendingPathComponent(folder) else {
            throw FileHandlerError.appendFolderError(folder)
        }
        
        do {
            try FileManager.default.createDirectory(atPath: writePath.path, withIntermediateDirectories: true)
        } catch {
            throw error
        }
        
        fileURL = writePath.appendingPathComponent(fileName)
    }
    
    /**
     Stores a Data object in the file at the URL created by init
     
     - parameters:
         - data: The Data object to store
     
     - throws: An error describing what went wrong
     */
    func write(_ data : Data) throws {
        do {
            try data.write(to: fileURL)
        } catch {
            throw FileHandlerError.writeError(error.localizedDescription)
        }
    }
    
    /**
     Reads data from the file at the URL created by init
     
     - returns: The Data object read from the file
     
     - throws: An error describing what went wrong
     */
    func read() throws -> Data {
        var readData : Data
        
        do {
            readData = try Data(contentsOf: fileURL)
        } catch {
            throw error
        }
        
        return readData
    }
    
    /**
     Deletes the file at the URL created by init
     
     - throws: An error describing what went wrong
     */
    func delete() throws {
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            throw error
        }
    }
}
