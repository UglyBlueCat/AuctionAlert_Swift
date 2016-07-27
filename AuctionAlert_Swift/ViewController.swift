//
//  ViewController.swift
//  AuctionAlert_Swift
//
//  Created by Robin Spinks on 06/07/2016.
//  Copyright © 2016 UglyBlueCat. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var titleLabel: AALabel!
    var realmEntry: UITextField!
    var objectEntry: UITextField!
    var priceEntry: UITextField!
    var searchButton: UIButton!
    var saveButton: UIButton!
    var listButton: UIButton!
    var deleteButton: UIButton!
    var resultsTable: UITableView!
    var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(newDataReceived), name: "kDataReceived", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(messageReceived), name: "kMessageReceived", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        positionObjectsWithinSize(size)
        resultsTable.reloadData()
    }
    
    /*
     * setupView()
     *
     * Set up the view
     */
    func setupView() {
        view.backgroundColor = primaryColor
        addObjects()
        positionObjectsWithinSize(view.bounds.size)
    }
    
    /*
     * addObjects()
     *
     * Add objects to the view
     */
    func addObjects() {
        titleLabel = AALabel()
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.textColor = textIconColor
        view.addSubview(titleLabel!)
        
        realmEntry = UITextField()
        realmEntry.placeholder = "Realm"
        realmEntry.textColor = textIconColor
        view.addSubview(realmEntry!)
        
        objectEntry = UITextField()
        objectEntry.placeholder = "Object"
        objectEntry.textColor = textIconColor
        view.addSubview(objectEntry!)
        
        priceEntry = UITextField()
        priceEntry.placeholder = "Maximum price (gold each)"
        priceEntry.textColor = textIconColor
        view.addSubview(priceEntry!)
        
        searchButton = UIButton()
        searchButton.setTitle("Search", forState: .Normal)
        searchButton.setTitleColor(textIconColor, forState: .Normal)
        searchButton.setBackgroundImage(UIImage(color: accentColor), forState: .Normal)
        searchButton.addTarget(self, action: #selector(searchButtonTapped), forControlEvents: .TouchUpInside)
        view.addSubview(searchButton!)
        
        saveButton = UIButton()
        saveButton.setTitle("Save", forState: .Normal)
        saveButton.setTitleColor(textIconColor, forState: .Normal)
        saveButton.setBackgroundImage(UIImage(color: accentColor), forState: .Normal)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), forControlEvents: .TouchUpInside)
        view.addSubview(saveButton!)
        
        listButton = UIButton()
        listButton.setTitle("List", forState: .Normal)
        listButton.setTitleColor(textIconColor, forState: .Normal)
        listButton.setBackgroundImage(UIImage(color: accentColor), forState: .Normal)
        listButton.addTarget(self, action: #selector(listButtonTapped), forControlEvents: .TouchUpInside)
        view.addSubview(listButton!)
        
        deleteButton = UIButton()
        deleteButton.setTitle("Delete", forState: .Normal)
        deleteButton.setTitleColor(textIconColor, forState: .Normal)
        deleteButton.setBackgroundImage(UIImage(color: accentColor), forState: .Normal)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), forControlEvents: .TouchUpInside)
        view.addSubview(deleteButton!)
        
        resultsTable = UITableView()
        resultsTable.backgroundColor = UIColor.clearColor()
        resultsTable.separatorStyle = .None
        
        resultsTable.dataSource = self
        resultsTable.delegate = self
        resultsTable.rowHeight = 56
        resultsTable.registerClass(SearchResultCell.self, forCellReuseIdentifier: "SearchResultCell")
        resultsTable.registerClass(SearchListCell.self, forCellReuseIdentifier: "SearchListCell")
        view.addSubview(resultsTable!)
        
        activityIndicator = UIActivityIndicatorView()
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
     * sizeObjects
     *
     * Sets the size of objects separately so this function can be called from different places
     */
    func positionObjectsWithinSize(size: CGSize) {
        
        let topMargin: CGFloat = 20.0
        let standardControlWidth: CGFloat = 200.0
        let standardControlHeight: CGFloat = 30.0
        let viewHeight : CGFloat = size.height
        let viewWidth : CGFloat = size.width
        let margin: CGFloat = (viewWidth + viewHeight)/100
        let numButtons: CGFloat = 4.0
        
        var buttonWidth : CGFloat
        if standardControlWidth*numButtons > viewWidth {
            buttonWidth = (viewWidth - (numButtons + 1)*margin)/numButtons
        } else {
            buttonWidth = standardControlWidth
        }
        
        let buttonGap = (viewWidth - numButtons*buttonWidth)/(numButtons + 1)
        
        let titleLabelFrame: CGRect = CGRect(x: margin,
                                             y: topMargin,
                                             width: viewWidth - 2*margin,
                                             height: standardControlHeight)
        titleLabel.frame = titleLabelFrame
        
        let realmEntryFrame: CGRect = CGRect(x: margin,
                                             y: CGRectGetMaxY(titleLabelFrame) + margin,
                                             width: viewWidth - 2*margin,
                                             height: standardControlHeight)

        realmEntry.frame = realmEntryFrame
        
        let objectEntryFrame: CGRect = CGRect(x: margin,
                                              y: CGRectGetMaxY(realmEntryFrame) + margin,
                                              width: viewWidth - 2*margin,
                                              height: standardControlHeight)
        objectEntry.frame = objectEntryFrame
        
        let priceEntryFrame: CGRect = CGRect(x: margin,
                                             y: CGRectGetMaxY(objectEntryFrame) + margin,
                                             width: viewWidth - 2*margin,
                                             height: standardControlHeight)
        priceEntry.frame = priceEntryFrame
        
        let searchButtonFrame: CGRect = CGRect(x: buttonGap,
                                               y: viewHeight - margin - standardControlHeight,
                                               width: buttonWidth,
                                               height: standardControlHeight)
        searchButton.frame = searchButtonFrame
        
        let saveButtonFrame: CGRect = CGRect(x: 2*buttonGap + buttonWidth,
                                               y: viewHeight - margin - standardControlHeight,
                                               width: buttonWidth,
                                               height: standardControlHeight)
        saveButton.frame = saveButtonFrame
        
        let listButtonFrame: CGRect = CGRect(x: 3*buttonGap + 2*buttonWidth,
                                               y: viewHeight - margin - standardControlHeight,
                                               width: buttonWidth,
                                               height: standardControlHeight)
        listButton.frame = listButtonFrame
        
        let deleteButtonFrame: CGRect = CGRect(x: 4*buttonGap + 3*buttonWidth,
                                               y: viewHeight - margin - standardControlHeight,
                                               width: buttonWidth,
                                               height: standardControlHeight)
        deleteButton.frame = deleteButtonFrame
        
        let resultsTableFrame: CGRect = CGRect(x: margin,
                                               y: CGRectGetMaxY(priceEntryFrame) + margin,
                                               width: viewWidth - 2*margin,
                                               height: CGRectGetMinY(searchButtonFrame) - CGRectGetMaxY(priceEntryFrame) - 2*margin)
        resultsTable.frame = resultsTableFrame
        
        let activityIndicatorFrame: CGRect = CGRect(x: (viewWidth - standardControlHeight)/2,
                                                    y: (viewHeight - standardControlHeight)/2,
                                                    width: standardControlHeight,
                                                    height: standardControlHeight)
        activityIndicator.frame = activityIndicatorFrame
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
     * saveButtonTapped()
     *
     * Respond to the tapping of the save button
     * Initiates the saving of a search with parameters entered
     */
    func saveButtonTapped() {
        let realm: String = realmEntry.text!
        let object: String = objectEntry.text!
        let price: String = priceEntry.text!
        DLog("Saving search for \(object) on \(realm) with a maximum price of \(price) gold each")
        API_Interface.saveSearch(realm, object: object, price: price)
    }
    
    /*
     * listButtonTapped()
     *
     * Respond to the tapping of the list button
     * Initiates the download of all current searches
     */
    func listButtonTapped() {
        DLog("listing all searches")
        activityIndicator.startAnimating()
        API_Interface.listAuctions()
    }
    
    /*
     * deleteButtonTapped()
     *
     * Respond to the tapping of the delete button
     * Initiates the deletion of the selected search
     */
    func deleteButtonTapped() {
        let realm: String = realmEntry.text!
        let object: String = objectEntry.text!
        let price: String = priceEntry.text!
        DLog("Deleting search for \(object) on \(realm) with a maximum price of \(price) gold each")
        activityIndicator.startAnimating()
        API_Interface.deleteAuction(realm, object: object, price: price)
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
    
    /*
     * messageReceived()
     *
     * Called when notification of message is received
     */
    func messageReceived() {
        DLog("Recieved message")
        activityIndicator.stopAnimating()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataHandler.sharedInstance.searchResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let singleResult: Dictionary<String, AnyObject> = DataHandler.sharedInstance.searchResults[indexPath.row]
        DLog("singleResult: \(singleResult)")
        
        if singleResult["quantity"] != nil {
            let cell:SearchResultCell = tableView.dequeueReusableCellWithIdentifier("SearchResultCell", forIndexPath: indexPath) as! SearchResultCell
            
            let quantity : Int = singleResult["quantity"]! as! Int
            let owner : String = singleResult["owner"]! as! String
            
            let bid : Int = singleResult["bid"]! as! Int
            let (bidGold, bidSilver, bidCopper) = ConvertMoney(bid)
            let bidString = "\(bidGold)g \(bidSilver)s \(bidCopper)c"
            
            let buyout : Int = singleResult["buyout"]! as! Int
            let (buyoutGold, buyoutSilver, buyoutCopper) = ConvertMoney(buyout)
            let buyoutString = "\(buyoutGold)g \(buyoutSilver)s \(buyoutCopper)c"
            
            cell.detailLabel!.text = "Stack size: \(quantity) Seller:\(owner)"
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
                cell.bidLabel!.text = "Current bid:\n\(bidString)"
                cell.buyoutLabel!.text = "Buyout:\n\(buyoutString)"
            } else {
                cell.bidLabel!.text = "Current bid: \(bidString)"
                cell.buyoutLabel!.text = "Buyout: \(buyoutString)"
            }
            
            return cell
        } else {
            let cell:SearchListCell = tableView.dequeueReusableCellWithIdentifier("SearchListCell", forIndexPath: indexPath) as! SearchListCell
            
            let realm : String = singleResult["realm"]! as! String
            let object : String = singleResult["object"]! as! String
            let price : Int = singleResult["price"]! as! Int
            DLog("price: \(price)")
            let (priceGold, priceSilver, priceCopper) = ConvertMoney(price*10000)
            let priceString = "\(priceGold)g \(priceSilver)s \(priceCopper)c"
            
            cell.detailLabel!.text = "Search for \(object) on \(realm) with a minimum price of \(priceString)"
            
            return cell
        }
    }
}

extension ViewController: UITableViewDelegate {
}
