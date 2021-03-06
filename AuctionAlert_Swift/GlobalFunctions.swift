//
//  GlobalFunctions.swift
//  AuctionAlert_Swift
//
//  Created by Robin Spinks on 14/07/2016.
//  Copyright © 2016 UglyBlueCat. All rights reserved.
//

import Foundation
import UIKit

let userDefaults: UserDefaults = UserDefaults.standard
let idForVendor: String? = UIDevice.current.identifierForVendor?.uuidString
let auctionAlertURL: String = "http://uglybluecat.com/AuctionAlert.php"
let battleHost : [String:String] = ["EU":"eu.api.battle.net",
                                    "US":"us.api.battle.net",
                                    "CN":"api.battlenet.com.cn",
                                    "KR":"kr.api.battle.net",
                                    "TW":"tw.api.battle.net"]
let battleAPIKey : String = "h4gsxvxsaggw4azvg2pfmv7wuzvqarsc"
let regionKey : String = "kRegion"
let languageKey : String = "kLanguage"
let localeKey : String = "kLocale"
let realmKey : String = "kRealm"
let deviceKey : String = "kDevice"
let battleIconWidth : CGFloat = 56.0

/**
 Prints a message to the console prefixed with filename, function & line number.
 A replacement for \_\_PRETTY_FUNCTION__
 
 - parameters:
    - msg: The message to print
    - function: The calling function or method (Defaults to #function)
    - file: The file containing function (Defaults to #file)
    - line: The line of the DLog call (Defaults to #line)
 */
func DLog(_ msg: String, function: String = #function, file: String = #file, line: Int = #line) {
    let url = URL(fileURLWithPath: file)
    let className:String = url.lastPathComponent
    print("[\(className) \(function)](\(line)) \(msg)")
}

/**
 Converts a monetary value into gold, silver & copper
 
 - parameter allCopper: The monetary value to convert
 - returns: 
    - gold:     The gold portion
    - silver:   The silver portion
    - copper:   The copper portion
 */
func ConvertMoney(_ allCopper: Int) -> (gold: Int, silver: Int, copper: Int) {
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
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
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
 * Colours
 */
let primaryColor = UIColor(hexString: "#515151")
let primaryTextColor = UIColor(hexString: "#FFFFFF")
let secondaryTextColor = UIColor(hexString: "#000000")
let primaryAccentColor = UIColor(hexString: "#C56309")
let secondaryAccentColor = UIColor(hexString: "#BA0C6A")
let primaryAttentionColor = UIColor(hexString: "#FF008B")
let secondaryAttentionColor = UIColor(hexString: "#E8A63D")
let pinkColor = UIColor(hexString: "#FF00FF")

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
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
