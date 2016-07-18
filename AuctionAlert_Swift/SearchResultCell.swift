//
//  SearchResultCell.swift
//  AuctionAlert_Swift
//
//  Created by Robin Spinks on 17/07/2016.
//  Copyright © 2016 UglyBlueCat. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {
    
    let margin: CGFloat = 10.0
    
    var detailLabel: UILabel!

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
        self.resizeLabel()
    }
    
    func setupView () {
        self.backgroundColor = UIColor.blueColor()
        detailLabel = UILabel()
        detailLabel.text = "Auction Alert"
        detailLabel.backgroundColor = UIColor.blackColor()
        detailLabel.textColor = UIColor.whiteColor()
        detailLabel.textAlignment = .Center
        self.addSubview(detailLabel!)
    }
    
    func resizeLabel() {
        let detailLabelFrame: CGRect = CGRect(x: margin,
                                              y: margin,
                                              width: self.bounds.size.width - 2*margin,
                                              height: self.bounds.size.height - 2*margin)
        detailLabel.frame = detailLabelFrame
    }
}
