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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(newImageReceived), name: "kImageReceived", object: nil)
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
        
        objectEntry = AATextField(placeHolder: "Object", handler: self, selector: #selector(objectNameEntered))
        view.addSubview(objectEntry!)
        
        priceEntry = AATextField(placeHolder: "Maximum price (gold each)", handler: self, selector: #selector(priceEntered))
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
        if let
            object : String = objectEntry.text,
            price : String = priceEntry.text
        {
            DLog("Searching for \(object) on \(userDefaults.stringForKey(realmKey)!) with a maximum price of \(price) gold each")
            activityIndicator.startAnimating()
            API_Interface.sharedInstance.searchAuction(object, price: price)
        }
    }
    
    /*
     * saveButtonTapped()
     *
     * Respond to the tapping of the save button
     * Initiates the saving of a search with parameters entered
     */
    func saveButtonTapped() {
        if let
            object : String = objectEntry.text,
            price : String = priceEntry.text
        {
            DLog("Saving search for \(object) on \(userDefaults.stringForKey(realmKey)!) with a maximum price of \(price) gold each")
            API_Interface.sharedInstance.saveSearch(object, price: price)
        }
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
        API_Interface.sharedInstance.listAuctions()
    }
    
    /*
     * deleteButtonTapped()
     *
     * Respond to the tapping of the delete button
     * Initiates the deletion of the selected search
     */
    func deleteButtonTapped() {
        if let
            object : String = objectEntry.text,
            price : String = priceEntry.text
        {
            DLog("Deleting search for \(object) on \(userDefaults.stringForKey(realmKey)!) with a maximum price of \(price) gold each")
            activityIndicator.startAnimating()
            API_Interface.sharedInstance.deleteAuction(object, price: price)
        }
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
     * Reloads the table and stops the activity indicator
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
        DLog("Received message")
        activityIndicator.stopAnimating()
    }
    
    /*
     * newImageReceived()
     *
     * Called when notification of new icon image download completion is received
     * Reloads the table
     */
    func newImageReceived() {
        if DataHandler.sharedInstance.searchResults.count > 0 {
            resultsTable!.reloadData()
        }
    }
    
    /*
     * objectNameEntered
     *
     * called after user edits object name text field
     */
    func objectNameEntered() {
        if let objectName: String = objectEntry.text {
            API_Interface.sharedInstance.checkCode(objectName)
        }
    }
    
    /*
     * priceEntered
     *
     * called after user edits price text field
     */
    func priceEntered() {
        if let priceStr : String = priceEntry.text {
            if let price : Int = Int(priceStr) {
                // price is int
            } else {
                presentAlert("Price needs to be in whole units of gold")
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataHandler.sharedInstance.searchResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let singleResult: Dictionary<String, AnyObject> = DataHandler.sharedInstance.searchResults[indexPath.row]
        
        if let quantity : Int = singleResult["quantity"] as? Int {
            let cell : SearchResultCell = tableView.dequeueReusableCellWithIdentifier("SearchResultCell", forIndexPath: indexPath) as! SearchResultCell
            
            let owner : String? = singleResult["owner"] as? String
            
            var bidString : String = ""
            if let bid : Int = singleResult["bid"] as? Int {
                let (bidGold, bidSilver, bidCopper) = ConvertMoney(bid)
                bidString = "\(bidGold)g \(bidSilver)s \(bidCopper)c"
            }
            
            var buyoutString : String = ""
            if let buyout : Int = singleResult["buyout"] as? Int {
                let (buyoutGold, buyoutSilver, buyoutCopper) = ConvertMoney(buyout)
                buyoutString = "\(buyoutGold)g \(buyoutSilver)s \(buyoutCopper)c"
            }
            
            cell.detailLabel!.text = "Stack size: \(quantity) Seller:\(owner ?? "")"
            
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
                cell.bidLabel!.text = "Current bid:\n\(bidString)"
                cell.buyoutLabel!.text = "Buyout:\n\(buyoutString)"
            } else {
                cell.bidLabel!.text = "Current bid: \(bidString)"
                cell.buyoutLabel!.text = "Buyout: \(buyoutString)"
            }
            
            if let code : Int = singleResult["item"] as? Int {
                cell.iconImage.image = ImageFetcher.sharedInstance.imageFromCode(String(code))
            }
            
            return cell
        } else if let realm : String = singleResult["realm"] as? String {
            let cell : SearchListCell = tableView.dequeueReusableCellWithIdentifier("SearchListCell", forIndexPath: indexPath) as! SearchListCell
            
            let object : String? = singleResult["object"] as? String
            
            var priceString : String = ""
            if let price : Int = singleResult["price"] as? Int {
                let (priceGold, priceSilver, priceCopper) = ConvertMoney(price*10000)
                priceString = "\(priceGold)g \(priceSilver)s \(priceCopper)c"
            }
            
            cell.detailLabel!.text = "Search for \(object ?? "") on \(realm ?? "") with a minimum price of \(priceString)"
            
            return cell
        } else {
            DLog("Cannot interpret data")
            let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")!
            return cell
        }
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let singleResult: Dictionary<String, AnyObject> = DataHandler.sharedInstance.searchResults[indexPath.row]
        if let realm: String = singleResult["realm"] as? String {
            userDefaults.setObject(realm.capitalizedString, forKey: realmKey)
            realmLabel.text = "Realm: \(realm.capitalizedString)"
            if let object: String = singleResult["object"] as? String {
                objectEntry.text = object
            }
            if let price: Int = singleResult["price"] as? Int {
                priceEntry.text = price.description
            }
            if let locale: String = singleResult["locale"] as? String {
                userDefaults.setObject(locale, forKey: localeKey)
                switch locale {
                case "en_GB":
                    userDefaults.setObject("EU", forKey: regionKey)
                    userDefaults.setObject("en", forKey: languageKey)
                case "de_DE":
                    userDefaults.setObject("EU", forKey: regionKey)
                    userDefaults.setObject("de", forKey: languageKey)
                case "es_ES":
                    userDefaults.setObject("EU", forKey: regionKey)
                    userDefaults.setObject("es", forKey: languageKey)
                case "fr_FR":
                    userDefaults.setObject("EU", forKey: regionKey)
                    userDefaults.setObject("fr", forKey: languageKey)
                case "it_IT":
                    userDefaults.setObject("EU", forKey: regionKey)
                    userDefaults.setObject("it", forKey: languageKey)
                case "pt_PT":
                    userDefaults.setObject("EU", forKey: regionKey)
                    userDefaults.setObject("pt", forKey: languageKey)
                case "ru_RU":
                    userDefaults.setObject("EU", forKey: regionKey)
                    userDefaults.setObject("ru", forKey: languageKey)
                case "en_US":
                    userDefaults.setObject("US", forKey: regionKey)
                    userDefaults.setObject("en", forKey: languageKey)
                case "es_MX":
                    userDefaults.setObject("US", forKey: regionKey)
                    userDefaults.setObject("es", forKey: languageKey)
                case "pt_BR":
                    userDefaults.setObject("US", forKey: regionKey)
                    userDefaults.setObject("pt", forKey: languageKey)
                case "zh_CN":
                    userDefaults.setObject("CN", forKey: regionKey)
                    userDefaults.setObject("zh", forKey: languageKey)
                case "ko_KR":
                    userDefaults.setObject("KR", forKey: regionKey)
                    userDefaults.setObject("ko", forKey: languageKey)
                case "zh_TW":
                    userDefaults.setObject("TW", forKey: regionKey)
                    userDefaults.setObject("zh", forKey: languageKey)
                default:
                    userDefaults.setObject("EU", forKey: regionKey)
                    userDefaults.setObject("en", forKey: languageKey)
                }
            }
        }
    }
}
