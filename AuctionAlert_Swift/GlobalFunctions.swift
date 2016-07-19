//
//  GlobalFunctions.swift
//  AuctionAlert_Swift
//
//  Created by Robin Spinks on 14/07/2016.
//  Copyright © 2016 UglyBlueCat. All rights reserved.
//

import Foundation

/*
 * DLog
 *
 * Prints a message to the console prefixed with filename, function & line number
 * A replacement for __PRETTY_FUNCTION__
 *
 * @param: msg:         String  - The message to print
 * @param: function:    String  - defaults to #function
 * @param: file:        String  - Defaults to #file
 * @param: line:        Int     - Defaults to #line
 */
func DLog(msg: String, function: String = #function, file: String = #file, line: Int = #line) {
    let url = NSURL(fileURLWithPath: file)
    let className:String! = url.lastPathComponent == nil ? file : url.lastPathComponent!
    print("[\(className) \(function)](\(line)) \(msg)")
}

func ConvertMoney(allCopper: Int) -> (gold: Int, silver: Int, copper: Int) {
    let gold : Int = Int(allCopper/10000)
    let silver : Int = Int((allCopper - gold*10000)/100)
    let copper : Int = allCopper - gold*10000 - silver*100
    return (gold, silver, copper)
}