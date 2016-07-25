//
//  AALabel.swift
//  AuctionAlert_Swift
//
//  Created by Robin Spinks on 20/07/2016.
//  Copyright © 2016 UglyBlueCat. All rights reserved.
//

import UIKit

class AALabel: UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupStandards()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStandards()
    }
    
    /*
     * setupStandards
     *
     * Sets up label attributes considered standard or default for this application
     */
    func setupStandards() {
        text = "Auction Alert"
        backgroundColor = UIColor.clearColor()
        textColor = textIconColor
        textAlignment = .Center
        adjustsFontSizeToFitWidth = true
        allowsDefaultTighteningForTruncation = true
        minimumScaleFactor = 0.5
    }
}
