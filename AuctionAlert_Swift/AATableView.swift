//
//  AATableView.swift
//  AuctionAlert_Swift
//
//  Created by Robin Spinks on 12/08/2016.
//  Copyright © 2016 UglyBlueCat. All rights reserved.
//

import UIKit

class AATableView: UITableView {

    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        if self.bounds.contains(point) {
            NSNotificationCenter.defaultCenter().postNotificationName("kTableTapped", object: self)
        }
        return super.hitTest(point, withEvent: event)
    }
}
