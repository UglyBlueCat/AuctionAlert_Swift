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
    
    convenience init(textStr: String) {
        self.init()
        text = textStr
    }
    
    /*
     * setupStandards
     *
     * Sets up label attributes considered standard or default for this application
     */
    func setupStandards() {
        backgroundColor = UIColor.clearColor()
        textColor = primaryTextColor
        textAlignment = .Center
        adjustsFontSizeToFitWidth = true
        allowsDefaultTighteningForTruncation = true
        minimumScaleFactor = 0.5
    }
}
