//
//  ImageFetcher.swift
//  AuctionAlert_Swift
//
//  Created by Robin Spinks on 07/08/2016.
//  Copyright © 2016 UglyBlueCat. All rights reserved.
//

import Foundation
import UIKit

class ImageFetcher {
    let defaultImage : UIImage = UIImage(color: UIColor.clearColor())!
    var currentCode : String?
    
    static let sharedInstance = ImageFetcher()
    private init() {
        currentCode = nil
    }
    
    /*
     * imageFromCode
     *
     * Returns an image named with an item code if it exists,
     * otherwise returns a default image and triggers download of the desired image
     *
     * @param: code: String - the item code
     * @return: UIImage     - the image
     */
    func imageFromCode (code: String) -> UIImage {
        let directory : NSSearchPathDirectory = .DocumentDirectory
        let domain : NSSearchPathDomainMask = .UserDomainMask
        let directoryURLs = NSFileManager.defaultManager().URLsForDirectory(directory, inDomains: domain)
        let imageLocation : NSURL = directoryURLs[0].URLByAppendingPathComponent("\(code).jpg")
        if let codeImage : UIImage = UIImage(contentsOfFile: imageLocation.relativePath!) {
            return codeImage
        } else {
            DLog("Cannot find image at \(imageLocation.URLString)")
        }
        if currentCode != code {
            API_Interface.sharedInstance.fetchObjectData(code)
            currentCode = code
        }
        return defaultImage
    }
    
    
    /*
     * downloadImage
     *
     * Downloads an image and stores it named with an item code
     *
     * @param: code: String - the item code
     * @param: name: String - the items icon name
     */
    func downloadImage (code: String, name: String) {
        let imageURL: String = "http://media.blizzard.com/wow/icons/56/\(name).jpg"
        
        API_Interface.sharedInstance.alamofireManager?.download(.GET, imageURL, destination: { (NSURL, NSHTTPURLResponse) -> NSURL in
            let directory : NSSearchPathDirectory = .DocumentDirectory
            let domain : NSSearchPathDomainMask = .UserDomainMask
            let directoryURLs = NSFileManager.defaultManager().URLsForDirectory(directory, inDomains: domain)
            return directoryURLs[0].URLByAppendingPathComponent("\(code).jpg")
        })
            .response { response in
                NSNotificationCenter.defaultCenter().postNotificationName("kImageReceived", object: self)
        }
    }
}