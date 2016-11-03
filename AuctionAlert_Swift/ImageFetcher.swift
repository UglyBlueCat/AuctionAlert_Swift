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
    let defaultImage : UIImage = UIImage(color: UIColor.clear)!
    var currentCode : String?
    
    static let sharedInstance = ImageFetcher()
    fileprivate init() {
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
    func imageFromCode (_ code: String) -> UIImage {
        let directory : FileManager.SearchPathDirectory = .documentDirectory
        let domain : FileManager.SearchPathDomainMask = .userDomainMask
        let directoryURLs = FileManager.default.urls(for: directory, in: domain)
        let imageLocation : URL = directoryURLs[0].appendingPathComponent("\(code).jpg")
        if let codeImage : UIImage = UIImage(contentsOfFile: imageLocation.relativePath) {
            return codeImage
        } else {
            DLog("Cannot find image at \(imageLocation.relativePath)")
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
    func downloadImage (_ code: String, name: String) {
        
        let imageURLString: String = "http://media.blizzard.com/wow/icons/56/\(name).jpg"
        
        if let imageURL : URL = URL(string: imageURLString) {
            
            let request : URLRequest = URLRequest(url: imageURL)
            
            NetworkManager.sharedInstance.handleRequest(request: request) { (data, urlResponse, error) in
                DLog("imageURLString: \(imageURLString)")
                
                let directory : FileManager.SearchPathDirectory = .documentDirectory
                let domain : FileManager.SearchPathDomainMask = .userDomainMask
                let directoryURLs = FileManager.default.urls(for: directory, in: domain)
                let imageFileURL : URL = directoryURLs[0].appendingPathComponent("\(code).jpg")
                DLog("imageFileURL: \(imageFileURL.debugDescription)")
                
                if (try? data!.write(to: imageFileURL, options: [])) != nil {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "kImageReceived"), object: nil)
                } else {
                    DLog("Unable to write to file: \(imageFileURL)")
                }
            }
        } else {
            DLog("Cannot construct URL from \(imageURLString)")
        }
    }
}
