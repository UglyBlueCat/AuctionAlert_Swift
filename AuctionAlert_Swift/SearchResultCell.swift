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
    let priceLabelWidth: CGFloat = 200.0
    
    var iconImage: UIImageView!
    var detailLabel: UILabel!
    var bidLabel: UILabel!
    var buyoutLabel: UILabel!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
        self.backgroundColor = UIColor.blueColor()
        
        iconImage = UIImageView()
        iconImage.backgroundColor = UIColor.blackColor()
        self.addSubview(iconImage!)
        
        detailLabel = UILabel()
        detailLabel.text = "Auction Alert"
        detailLabel.backgroundColor = UIColor.blackColor()
        detailLabel.textColor = UIColor.whiteColor()
        detailLabel.textAlignment = .Center
        self.addSubview(detailLabel!)
        
        bidLabel = UILabel()
        bidLabel.text = "Auction Alert"
        bidLabel.backgroundColor = UIColor.blackColor()
        bidLabel.textColor = UIColor.whiteColor()
        bidLabel.textAlignment = .Center
        self.addSubview(bidLabel!)
        
        buyoutLabel = UILabel()
        buyoutLabel.text = "Auction Alert"
        buyoutLabel.backgroundColor = UIColor.blackColor()
        buyoutLabel.textColor = UIColor.whiteColor()
        buyoutLabel.textAlignment = .Center
        self.addSubview(buyoutLabel!)
    }
    
    /*
     * sizeObjects()
     *
     * Change the size of objects in the cell
     * These are in a seperate function so they can be called from layoutSubviews()
     */
    func sizeObjects() {
        let iconWidth : CGFloat = self.bounds.size.height - 2*margin
        let iconImageFrame: CGRect = CGRect(x: margin,
                                            y: margin,
                                            width: iconWidth,
                                            height: iconWidth)
        iconImage.frame = iconImageFrame
        
        let bidLabelFrame: CGRect = CGRect(x: self.bounds.size.width - (priceLabelWidth + margin),
                                           y: margin,
                                           width: priceLabelWidth,
                                           height: self.bounds.size.height/2 - 1.5*margin)
        bidLabel.frame = bidLabelFrame
        
        let buyoutLabelFrame: CGRect = CGRect(x: self.bounds.size.width - (priceLabelWidth + margin),
                                              y: self.bounds.size.height/2 + 0.5*margin,
                                              width: priceLabelWidth,
                                              height: self.bounds.size.height/2 - 1.5*margin)
        buyoutLabel.frame = buyoutLabelFrame
        
        let detailLabelFrame: CGRect = CGRect(x: iconWidth + 2*margin,
                                              y: margin,
                                              width: self.bounds.size.width - (priceLabelWidth + iconWidth + 4*margin),
                                              height: self.bounds.size.height - 2*margin)
        detailLabel.frame = detailLabelFrame
    }
}
