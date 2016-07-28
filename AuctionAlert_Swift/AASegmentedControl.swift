//
//  AASegmentedControl.swift
//  AuctionAlert_Swift
//
//  Created by Robin Spinks on 28/07/2016.
//  Copyright © 2016 UglyBlueCat. All rights reserved.
//

import UIKit

class AASegmentedControl: UISegmentedControl {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupStandards()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStandards()
    }
    
    override init(items: [AnyObject]?) {
        super.init(items: items)
        setupStandards()
    }
    
    convenience init(items: [AnyObject]?, handler: AnyObject, selector: Selector) {
        self.init(items: items)
        addTarget(handler, action: selector, forControlEvents: .ValueChanged)
    }
    
    /*
     * setupStandards
     *
     * Sets up attributes considered standard or default for this application
     */
    func setupStandards() {
        tintColor = primaryTextColor
    }
}
