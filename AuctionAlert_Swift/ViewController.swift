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
    var realmLabel: AALabel!
    var objectEntry: AATextField!
    var priceEntry: AATextField!
    var searchButton: AAButton!
    var saveButton: AAButton!
    var listButton: AAButton!
    var deleteButton: AAButton!
    var resultsTable: UITableView!
    var activityIndicator: UIActivityIndicatorView!
    var settingsButton: AAButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(newDataReceived), name: "kDataReceived", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(messageReceived), name: "kMessageReceived", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        if let realm : String = userDefaults.stringForKey(realmKey) {
            realmLabel.text = "Realm: \(realm)"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
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
        titleLabel = AALabel(textStr: "Auction Alert")
        view.addSubview(titleLabel!)
        
        realmLabel = AALabel(textStr: "Realm: \(userDefaults.stringForKey(realmKey)!)")
        realmLabel.textAlignment = .Left
        view.addSubview(realmLabel!)
        
        objectEntry = AATextField(placeHolder: "Object")
        view.addSubview(objectEntry!)
        
        priceEntry = AATextField(placeHolder: "Maximum price (gold each)")
        view.addSubview(priceEntry!)
        
        searchButton = AAButton(title: "Search", handler: self, selector: #selector(searchButtonTapped))
        view.addSubview(searchButton!)
        
        saveButton = AAButton(title: "Save", handler: self, selector: #selector(saveButtonTapped))
        view.addSubview(saveButton!)
        
        listButton = AAButton(title: "List", handler: self, selector: #selector(listButtonTapped))
        view.addSubview(listButton!)
        
        deleteButton = AAButton(title: "Delete", handler: self, selector: #selector(deleteButtonTapped))
        view.addSubview(deleteButton!)
        
        resultsTable = UITableView()
        resultsTable.backgroundColor = UIColor.clearColor()
        resultsTable.separatorStyle = .None
        resultsTable.dataSource = self
        resultsTable.delegate = self
        resultsTable.rowHeight = 56
        resultsTable.backgroundView = UIImageView(image: UIImage(named: "goblin_rogue"))
        resultsTable.registerClass(SearchResultCell.self, forCellReuseIdentifier: "SearchResultCell")
        resultsTable.registerClass(SearchListCell.self, forCellReuseIdentifier: "SearchListCell")
        view.addSubview(resultsTable!)
        
        activityIndicator = UIActivityIndicatorView()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        }
        view.addSubview(activityIndicator)
        
        settingsButton = AAButton(title: "", handler: self, selector: #selector(settingsButtonTapped))
        settingsButton.setBackgroundImage(UIImage(named: "settings_icon"), forState: .Normal)
        settingsButton.tintColor = primaryTextColor
        view.addSubview(settingsButton)
        
        // TODO: Remove temporary debugging code
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
        let settingsButtonWidth: CGFloat = standardControlHeight
        
        var buttonWidth : CGFloat
        if standardControlWidth*numButtons > viewWidth - (numButtons + 1)*margin {
            buttonWidth = (viewWidth - (numButtons + 1)*margin)/numButtons
        } else {
            buttonWidth = standardControlWidth
        }
        
        let buttonGap = (viewWidth - numButtons*buttonWidth)/(numButtons + 1)
        
        settingsButton.frame = CGRect(x: viewWidth - (settingsButtonWidth + margin),
                                      y: topMargin,
                                      width: settingsButtonWidth,
                                      height: settingsButtonWidth)
        
        titleLabel.frame = CGRect(x: margin + settingsButtonWidth,
                                  y: topMargin,
                                  width: viewWidth - (4*margin + 2*settingsButtonWidth),
                                  height: standardControlHeight)
        
        realmLabel.frame = CGRect(x: margin,
                                  y: CGRectGetMaxY(titleLabel.frame) + margin,
                                  width: viewWidth - 2*margin,
                                  height: standardControlHeight)
        
        objectEntry.frame = CGRect(x: margin,
                                   y: CGRectGetMaxY(realmLabel.frame) + margin,
                                   width: viewWidth - 2*margin,
                                   height: standardControlHeight)
        
        priceEntry.frame = CGRect(x: margin,
                                  y: CGRectGetMaxY(objectEntry.frame) + margin,
                                  width: viewWidth - 2*margin,
                                  height: standardControlHeight)
        
        searchButton.frame = CGRect(x: buttonGap,
                                    y: viewHeight - margin - standardControlHeight,
                                    width: buttonWidth,
                                    height: standardControlHeight)
        
        saveButton.frame = CGRect(x: 2*buttonGap + buttonWidth,
                                  y: viewHeight - margin - standardControlHeight,
                                  width: buttonWidth,
                                  height: standardControlHeight)
        
        listButton.frame = CGRect(x: 3*buttonGap + 2*buttonWidth,
                                  y: viewHeight - margin - standardControlHeight,
                                  width: buttonWidth,
                                  height: standardControlHeight)
        
        deleteButton.frame = CGRect(x: 4*buttonGap + 3*buttonWidth,
                                    y: viewHeight - margin - standardControlHeight,
                                    width: buttonWidth,
                                    height: standardControlHeight)
        
        resultsTable.frame = CGRect(x: margin,
                                    y: CGRectGetMaxY(priceEntry.frame) + margin,
                                    width: viewWidth - 2*margin,
                                    height: CGRectGetMinY(searchButton.frame) - CGRectGetMaxY(priceEntry.frame) - 2*margin)
        
        activityIndicator.frame = CGRect(x: (viewWidth - standardControlHeight)/2,
                                         y: (viewHeight - standardControlHeight)/2,
                                         width: standardControlHeight,
                                         height: standardControlHeight)
    }
    
    /*
     * searchButtonTapped()
     *
     * Respond to the tapping of the search button
     * Initiates the download of new data with parameters entered
     */
    func searchButtonTapped() {
        let object: String = objectEntry.text!
        let price: String = priceEntry.text!
        DLog("Searching for \(object) on \(userDefaults.stringForKey(realmKey)!) with a maximum price of \(price) gold each")
        activityIndicator.startAnimating()
        API_Interface.searchAuction(object, price: price)
    }
    
    /*
     * saveButtonTapped()
     *
     * Respond to the tapping of the save button
     * Initiates the saving of a search with parameters entered
     */
    func saveButtonTapped() {
        let object: String = objectEntry.text!
        let price: String = priceEntry.text!
        DLog("Saving search for \(object) on \(userDefaults.stringForKey(realmKey)!) with a maximum price of \(price) gold each")
        API_Interface.saveSearch(object, price: price)
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
        let object: String = objectEntry.text!
        let price: String = priceEntry.text!
        DLog("Deleting search for \(object) on \(userDefaults.stringForKey(realmKey)!) with a maximum price of \(price) gold each")
        activityIndicator.startAnimating()
        API_Interface.deleteAuction(object, price: price)
    }
    
    /*
     * deleteButtonTapped()
     *
     * Respond to the tapping of the delete button
     * Initiates the deletion of the selected search
     */
    func settingsButtonTapped() {
        DLog("")
        let settingsVC : SettingsVC = SettingsVC()
        presentViewController(settingsVC, animated: true, completion: nil)
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
            let (priceGold, priceSilver, priceCopper) = ConvertMoney(price*10000)
            let priceString = "\(priceGold)g \(priceSilver)s \(priceCopper)c"
            
            cell.detailLabel!.text = "Search for \(object) on \(realm) with a minimum price of \(priceString)"
            
            return cell
        }
    }
}

extension ViewController: UITableViewDelegate {
}
