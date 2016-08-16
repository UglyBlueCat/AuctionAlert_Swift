//
//  AATableView.swift
//  AuctionAlert_Swift
//
//  Created by Robin Spinks on 12/08/2016.
//  Copyright © 2016 UglyBlueCat. All rights reserved.
//

import UIKit

class AATableView: UITableView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupStandards()
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        setupStandards()
    }
    
    /*
     * setupStandards
     *
     * Sets up tableview attributes considered standard or default for this application
     */
    func setupStandards() {
        backgroundColor = UIColor.clearColor()
        separatorStyle = .None
    }

    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        if self.bounds.contains(point) {
            NSNotificationCenter.defaultCenter().postNotificationName("kTableTapped", object: self)
        }
        return super.hitTest(point, withEvent: event)
    }
}
