//
//  GlobalFunctions.swift
//  AuctionAlert_Swift
//
//  Created by Robin Spinks on 14/07/2016.
//  Copyright © 2016 UglyBlueCat. All rights reserved.
//

import Foundation
import UIKit

let idForVendor: String? = UIDevice.currentDevice().identifierForVendor?.UUIDString
let auctionAlertURL: String = "http://uglybluecat.com/AuctionAlert.php"

/*
 * DLog
 *
 * Prints a message to the console prefixed with filename, function & line number
 * A replacement for __PRETTY_FUNCTION__
 *
 * @param: msg:      String  - The message to print
 * @param: function: String  - Defaults to #function
 * @param: file:     String  - Defaults to #file
 * @param: line:     Int     - Defaults to #line
 */
func DLog(msg: String, function: String = #function, file: String = #file, line: Int = #line) {
    let url = NSURL(fileURLWithPath: file)
    let className:String! = url.lastPathComponent == nil ? file : url.lastPathComponent!
    print("[\(className) \(function)](\(line)) \(msg)")
}

/*
 * ConvertMoney
 *
 * Converts a monetary value into gold, silver & copper
 *
 * @param: allCopper: Int  - The monetary value to convert
 * @return: gold:     Int  - The gold portion
 * @return: silver:   Int  - The silver portion
 * @return: copper:   Int  - The copper portion
 */
func ConvertMoney(allCopper: Int) -> (gold: Int, silver: Int, copper: Int) {
    let gold : Int = Int(allCopper/10000)
    let silver : Int = Int((allCopper - gold*10000)/100)
    let copper : Int = allCopper - gold*10000 - silver*100
    return (gold, silver, copper)
}

/*
 * Create colour from hex string.
 * Taken from http://stackoverflow.com/questions/24263007/how-to-use-hex-colour-values-in-swift-ios
 */
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.alphanumericCharacterSet().invertedSet)
        var int = UInt32()
        NSScanner(string: hex).scanHexInt(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

/*
 * Colours chosen using http://www.materialpalette.com/purple/cyan
 */
let darkPrimaryColor = UIColor(hexString: "#512DA8")
let primaryColor = UIColor(hexString: "#673AB7")
let lightPrimaryColor = UIColor(hexString: "#D1C4E9")
let textIconColor = UIColor(hexString: "#FFFFFF")
let accentColor = UIColor(hexString: "#536DFE")
let primaryTextColor = UIColor(hexString: "#212121")
let secondaryTextColor = UIColor(hexString: "#727272")
let dividerColor = UIColor(hexString: "#B6B6B6")

/*
 * Create image from colour
 * Taken from http://stackoverflow.com/questions/26542035/create-uiimage-with-solid-color-in-swift
 */
public extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image.CGImage else { return nil }
        self.init(CGImage: cgImage)
    }
}

/*
 * presentAlert
 *
 * Presents an alert to the user
 *
 * @param: message: String - the message to present to the user
 */
func presentAlert (message: String) {
    let alert = UIAlertController(title: "Auction Alert", message: message, preferredStyle: .Alert)
    let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
    alert.addAction(action)
    
    if let topController = UIApplication.topViewController() {
        topController.presentViewController(alert, animated: true, completion: nil)
    } else {
        DLog("Unable to present alert for message: \(message)")
    }
}

/*
 * Find top view controller
 * from http://stackoverflow.com/questions/26667009/get-top-most-uiviewcontroller
 */
extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}