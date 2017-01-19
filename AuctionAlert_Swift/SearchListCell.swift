//
//  SearchListCell.swift
//  AuctionAlert_Swift
//
//  Created by Robin Spinks on 26/07/2016.
//  Copyright © 2016 UglyBlueCat. All rights reserved.
//

import UIKit

class SearchListCell: UITableViewCell {
    
    let margin: CGFloat = 0.0
    
    var detailLabel: AALabel!
    
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
     Set up objects in the cell.
     Separate from sizeObjects() so it can be called from initialisers
     */
    func setupView() {
        self.backgroundColor = UIColor.clear
        selectionStyle = .none
        
        detailLabel = AALabel()
        detailLabel.numberOfLines = 2
        self.addSubview(detailLabel!)
    }
    
    /**
     Change the size of objects in the cell.
     These are in a separate function so they can be called from layoutSubviews()
     */
    func sizeObjects() {
        let cellHeight : CGFloat = bounds.size.height
        let cellWidth : CGFloat = bounds.size.width
        
        detailLabel.frame = CGRect(x: margin,
                                   y: margin,
                                   width: cellWidth - 2*margin,
                                   height: cellHeight - 2*margin)
    }
}
