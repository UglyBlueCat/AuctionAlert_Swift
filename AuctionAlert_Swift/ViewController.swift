//
//  ViewController.swift
//  AuctionAlert_Swift
//
//  Created by Robin Spinks on 06/07/2016.
//  Copyright © 2016 UglyBlueCat. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let topMargin: CGFloat = 20.0
    let margin: CGFloat = 10.0
    let standardControlWidth: CGFloat = 200.0
    let standardControlHeight: CGFloat = 30.0
    
    var titleLabel: UILabel!
    var realmEntry: UITextField!
    var objectEntry: UITextField!
    var searchButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setupView() {
        self.view.backgroundColor = UIColor(red: 123/256, green: 31/256, blue: 162/256, alpha: 1)
        addObjects()
    }
    
    func addObjects() {
        let titleLabelFrame: CGRect = CGRect(x: margin,
                                             y: topMargin,
                                             width: self.view.bounds.size.width - 2*margin,
                                             height: standardControlHeight)
        titleLabel = UILabel(frame: titleLabelFrame)
        titleLabel.text = "Auction Alert"
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = .Center
        self.view.addSubview(titleLabel)
        
        let realmEntryFrame: CGRect = CGRect(x: margin,
                                             y: CGRectGetMaxY(titleLabelFrame) + margin,
                                             width: self.view.bounds.size.width - 2*margin,
                                             height: standardControlHeight)
        realmEntry = UITextField(frame: realmEntryFrame)
        realmEntry.placeholder = "Realm"
        self.view.addSubview(realmEntry)
        
        let objectEntryFrame: CGRect = CGRect(x: margin,
                                              y: CGRectGetMaxY(realmEntryFrame) + margin,
                                              width: self.view.bounds.size.width - 2*margin,
                                              height: standardControlHeight)
        objectEntry = UITextField(frame: objectEntryFrame)
        objectEntry.placeholder = "Object"
        self.view.addSubview(objectEntry)
        
        let searchButtonFrame: CGRect = CGRect(x: (self.view.bounds.size.width - standardControlWidth) / 2,
                                               y: self.view.bounds.size.height - margin - standardControlHeight,
                                               width: standardControlWidth,
                                               height: standardControlHeight)
        searchButton = UIButton(frame: searchButtonFrame)
        searchButton.setTitle("Search", forState: .Normal)
        searchButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.view.addSubview(searchButton)
    }
    
    
}
