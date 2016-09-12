//
//  AAButton.swift
//  AuctionAlert_Swift
//
//  Created by Robin Spinks on 28/07/2016.
//  Copyright © 2016 UglyBlueCat. All rights reserved.
//

import UIKit

class AAButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupStandards()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStandards()
    }
    
    convenience init(title: String, handler: AnyObject, selector: Selector) {
        self.init()
        setTitle(title, forState: .Normal)
        addTarget(handler, action: selector, forControlEvents: .TouchUpInside)
    }
    
    /*
     * setupStandards
     *
     * Sets up attributes considered standard or default for this application
     */
    func setupStandards() {
        setTitleColor(primaryTextColor, forState: .Normal)
        layer.cornerRadius = 5
        layer.borderWidth = 2
        layer.borderColor = primaryTextColor.CGColor
    }
}
