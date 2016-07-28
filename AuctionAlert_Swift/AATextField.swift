//
//  AATextField.swift
//  AuctionAlert_Swift
//
//  Created by Robin Spinks on 28/07/2016.
//  Copyright © 2016 UglyBlueCat. All rights reserved.
//

import UIKit

class AATextField: UITextField {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupStandards()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStandards()
    }
    
    convenience init(placeHolder: String) {
        self.init()
        placeholder = placeHolder
    }
    
    /*
     * setupStandards
     *
     * Sets up attributes considered standard or default for this application
     */
    func setupStandards() {
        textColor = primaryTextColor
    }
}
