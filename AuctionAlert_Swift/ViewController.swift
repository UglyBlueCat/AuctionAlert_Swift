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
    let margin: CGFloat = 20.0
    let standardControlWidth: CGFloat = 200.0
    let standardControlHeight: CGFloat = 30.0
    
    var titleLabel: UILabel!
    var realmEntry: UITextField!
    var objectEntry: UITextField!
    var priceEntry: UITextField!
    var searchButton: UIButton!
    var resultsTable: UITableView!
    var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(newDataReceived), name: "kDataRecieved", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*
     * setupView()
     *
     * Set up the view
     */
    func setupView() {
        view.backgroundColor = UIColor(red: 123/256, green: 31/256, blue: 162/256, alpha: 1)
        addObjects()
    }
    
    /*
     * addObjects()
     *
     * Add objects to the view
     */
    func addObjects() {
        let titleLabelFrame: CGRect = CGRect(x: margin,
                                             y: topMargin,
                                             width: view.bounds.size.width - 2*margin,
                                             height: standardControlHeight)
        titleLabel = UILabel(frame: titleLabelFrame)
        titleLabel.text = "Auction Alert"
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = .Center
        view.addSubview(titleLabel!)
        
        let realmEntryFrame: CGRect = CGRect(x: margin,
                                             y: CGRectGetMaxY(titleLabelFrame) + margin,
                                             width: view.bounds.size.width - 2*margin,
                                             height: standardControlHeight)
        realmEntry = UITextField(frame: realmEntryFrame)
        realmEntry.placeholder = "Realm"
        realmEntry.textColor = UIColor.whiteColor()
        view.addSubview(realmEntry!)
        
        let objectEntryFrame: CGRect = CGRect(x: margin,
                                              y: CGRectGetMaxY(realmEntryFrame) + margin,
                                              width: view.bounds.size.width - 2*margin,
                                              height: standardControlHeight)
        objectEntry = UITextField(frame: objectEntryFrame)
        objectEntry.placeholder = "Object"
        objectEntry.textColor = UIColor.whiteColor()
        view.addSubview(objectEntry!)
        view.addSubview(realmEntry!)
        
        let priceEntryFrame: CGRect = CGRect(x: margin,
                                              y: CGRectGetMaxY(objectEntryFrame) + margin,
                                              width: view.bounds.size.width - 2*margin,
                                              height: standardControlHeight)
        priceEntry = UITextField(frame: priceEntryFrame)
        priceEntry.placeholder = "Maximum price (gold each)"
        priceEntry.textColor = UIColor.whiteColor()
        view.addSubview(priceEntry!)
        
        let searchButtonFrame: CGRect = CGRect(x: (view.bounds.size.width - standardControlWidth) / 2,
                                               y: view.bounds.size.height - margin - standardControlHeight,
                                               width: standardControlWidth,
                                               height: standardControlHeight)
        searchButton = UIButton(frame: searchButtonFrame)
        searchButton.setTitle("Search", forState: .Normal)
        searchButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        searchButton.addTarget(self, action: #selector(searchButtonTapped), forControlEvents: .TouchUpInside)
        view.addSubview(searchButton!)
        
        let resultsTableFrame: CGRect = CGRect(x: margin,
                                               y: CGRectGetMaxY(priceEntryFrame) + margin,
                                               width: view.bounds.size.width - 2*margin,
                                               height: CGRectGetMinY(searchButtonFrame) - CGRectGetMaxY(priceEntryFrame) - 2*margin)
        resultsTable = UITableView(frame: resultsTableFrame)
        resultsTable.backgroundColor = UIColor.init(colorLiteralRed: 1.0, green: 0, blue: 1.0, alpha: 1)
        resultsTable.dataSource = self
        resultsTable.delegate = self
        resultsTable.rowHeight = 60
        resultsTable.registerClass(SearchResultCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(resultsTable!)
        
        let activityIndicatorFrame: CGRect = CGRect(x: (view.bounds.size.width - standardControlHeight)/2,
                                                    y: (view.bounds.size.height - standardControlHeight)/2,
                                                    width: standardControlHeight,
                                                    height: standardControlHeight)
        activityIndicator = UIActivityIndicatorView(frame: activityIndicatorFrame)
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        }
        view.addSubview(activityIndicator)
        
        // TODO: Remove temporary debugging code
        realmEntry.text = "Hellfire"
        objectEntry.text = "silk cloth"
        priceEntry.text = "10"
    }
    
    /*
     * searchButtonTapped()
     *
     * Respond to the tapping of the search button
     * Initiates the download of new data with parameters entered
     */
    func searchButtonTapped() {
        let realm: String = realmEntry.text!
        let object: String = objectEntry.text!
        let price: String = priceEntry.text!
        DLog("Searching for \(object) on \(realm) with a maximum price of \(price) gold each")
        activityIndicator.startAnimating()
        API_Interface.searchAuction(realm, object: object, price: price)
    }
    
    /*
     * newDataReceived()
     *
     * Called when notification of new data download completion is received
     * Reloads the table
     */
    func newDataReceived() {
        DLog("Recieved: \(DataHandler.sharedInstance.searchResults.count) objects")
        resultsTable!.reloadData()
        activityIndicator.stopAnimating()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataHandler.sharedInstance.searchResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:SearchResultCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! SearchResultCell
        let singleResult: Dictionary<String, AnyObject> = DataHandler.sharedInstance.searchResults[indexPath.row]
        
        let quantity : Int = singleResult["quantity"]! as! Int
        let owner : String = singleResult["owner"]! as! String
        
        let bid : Int = singleResult["bid"]! as! Int
        let (bidGold, bidSilver, bidCopper) = ConvertMoney(bid)
        let bidString = "\(bidGold)g \(bidSilver)s \(bidCopper)c"
        
        let buyout : Int = singleResult["buyout"]! as! Int
        let (buyoutGold, buyoutSilver, buyoutCopper) = ConvertMoney(buyout)
        let buyoutString = "\(buyoutGold)g \(buyoutSilver)s \(buyoutCopper)c"
        
        cell.detailLabel!.text = "Stack size:\(quantity) Seller:\(owner)"
        cell.bidLabel!.text = "Current bid: \(bidString)"
        cell.buyoutLabel!.text = "Buyout: \(buyoutString)"
        return cell
    }
}

extension ViewController: UITableViewDelegate {
}
