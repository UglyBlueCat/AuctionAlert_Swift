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
    var stackSizeLabel: AALabel!

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
    
    /**
     Set up objects in the cell..
     Seperate from sizeObjects() so it can be called from initialisers.
     */
    func setupView() {
        self.backgroundColor = UIColor.clear
        selectionStyle = .none
        
        iconImage = UIImageView()
        iconImage.backgroundColor = UIColor.clear
        self.addSubview(iconImage!)
        
        detailLabel = AALabel()
        detailLabel.numberOfLines = 2
        self.addSubview(detailLabel!)
        
        bidLabel = AALabel()
        self.addSubview(bidLabel!)
        
        buyoutLabel = AALabel()
        self.addSubview(buyoutLabel!)
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            let currentFontSize: CGFloat = bidLabel.font.pointSize
            let currentFont: UIFont = bidLabel.font
            bidLabel.font = currentFont.withSize(currentFontSize/2)
            buyoutLabel.font = currentFont.withSize(currentFontSize/2)
            bidLabel.numberOfLines = 2
            buyoutLabel.numberOfLines = 2
        }
        
        stackSizeLabel = AALabel()
        stackSizeLabel.backgroundColor = UIColor.clear
        self.addSubview(stackSizeLabel!)
    }
    
    /**
     Change the size of objects in the cell.
     These are in a seperate function so they can be called from layoutSubviews()
     */
    func sizeObjects() {
        let cellHeight : CGFloat = bounds.size.height
        let cellWidth : CGFloat = bounds.size.width
        let iconWidth : CGFloat = cellHeight - margin
        let priceLabelWidth: CGFloat = 0.3*cellWidth
        
        iconImage.frame = CGRect(x: margin,
                                 y: margin/2,
                                 width: iconWidth,
                                 height: iconWidth)
        
        stackSizeLabel.frame = CGRect(x: margin + iconWidth/2,
                                      y: margin/2 + iconWidth/2,
                                      width: iconWidth/2,
                                      height: iconWidth/2)
    
        bidLabel.frame = CGRect(x: cellWidth - (priceLabelWidth + margin),
                                y: margin/2,
                                width: priceLabelWidth,
                                height: cellHeight/2 - margin)
    
        buyoutLabel.frame = CGRect(x: cellWidth - (priceLabelWidth + margin),
                                   y: cellHeight/2 + margin/2,
                                   width: priceLabelWidth,
                                   height: cellHeight/2 - margin)
    
        detailLabel.frame = CGRect(x: iconWidth + 2*margin,
                                   y: margin/2,
                                   width: cellWidth - (priceLabelWidth + iconWidth + 4*margin),
                                   height: cellHeight - margin)
    }
}
