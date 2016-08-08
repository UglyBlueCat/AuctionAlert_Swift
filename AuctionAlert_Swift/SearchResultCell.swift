//
//  SearchResultCell.swift
//  AuctionAlert_Swift
//
//  Created by Robin Spinks on 17/07/2016.
//  Copyright © 2016 UglyBlueCat. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {
    
    let margin: CGFloat = 2.0
    
    var iconImage: UIImageView!
    var detailLabel: AALabel!
    var bidLabel: AALabel!
    var buyoutLabel: AALabel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.sizeObjects()
    }
    
    /*
     * setupView()
     *
     * Set up objects in the cell. 
     * Seperate from sizeObjects() so it can be called from initialisers
     */
    func setupView() {
        self.backgroundColor = UIColor.clearColor()
        
        iconImage = UIImageView()
        iconImage.backgroundColor = UIColor.clearColor()
        self.addSubview(iconImage!)
        
        detailLabel = AALabel()
        detailLabel.numberOfLines = 2
        self.addSubview(detailLabel!)
        
        bidLabel = AALabel()
        self.addSubview(bidLabel!)
        
        buyoutLabel = AALabel()
        self.addSubview(buyoutLabel!)
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            let currentFontSize: CGFloat = bidLabel.font.pointSize
            let currentFont: UIFont = bidLabel.font
            bidLabel.font = currentFont.fontWithSize(currentFontSize/2)
            buyoutLabel.font = currentFont.fontWithSize(currentFontSize/2)
            bidLabel.numberOfLines = 2
            buyoutLabel.numberOfLines = 2
        }
    }
    
    /*
     * sizeObjects()
     *
     * Change the size of objects in the cell
     * These are in a seperate function so they can be called from layoutSubviews()
     */
    func sizeObjects() {
        let cellHeight : CGFloat = bounds.size.height
        let cellWidth : CGFloat = bounds.size.width
        let iconWidth : CGFloat = cellHeight - 2*margin
        let priceLabelWidth: CGFloat = 0.2*cellWidth
        
        iconImage.frame = CGRect(x: margin,
                                 y: margin,
                                 width: iconWidth,
                                 height: iconWidth)
    
        bidLabel.frame = CGRect(x: cellWidth - (priceLabelWidth + margin),
                                y: margin,
                                width: priceLabelWidth,
                                height: cellHeight/2 - 1.5*margin)
    
        buyoutLabel.frame = CGRect(x: cellWidth - (priceLabelWidth + margin),
                                   y: cellHeight/2 + 0.5*margin,
                                   width: priceLabelWidth,
                                   height: cellHeight/2 - 1.5*margin)
    
        detailLabel.frame = CGRect(x: iconWidth + 2*margin,
                                   y: margin,
                                   width: cellWidth - (priceLabelWidth + iconWidth + 4*margin),
                                   height: cellHeight - 2*margin)
    }
}
