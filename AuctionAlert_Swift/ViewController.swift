//
//  ViewController.swift
//  AuctionAlert_Swift
//
//  Created by Robin Spinks on 06/07/2016.
//  Copyright © 2016 UglyBlueCat. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var realmLabel: AALabel!
    var itemLabel: AALabel!
    var maxPriceLabel: AALabel!
    
    var objectEntry: AATextField!
    var priceEntry: AATextField!
    
    var searchButton: AAButton!
    var saveButton: AAButton!
    var listButton: AAButton!
    var deleteButton: AAButton!
    var settingsButton: AAButton!
    
    var resultsTable: AATableView!
    
    var activityIndicator: UIActivityIndicatorView!
    
    var presentingAlert: Bool!
    var validItemName: Bool!
    var readyForAction: Bool!
    
    var logoImageView: UIImageView!
    var topBackground: UIImageView!
    var bottomBackground: UIImageView!
    var titleImage: UIImageView!
    var objectBG: UIImageView!
    var priceBG: UIImageView!
    var itemLabelBG: UIImageView!
    var objectLHS: UIImageView!
    
    // MARK: - UIViewController Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        presentingAlert = false
        validItemName = false
        readyForAction = true
        setupView()
        NotificationCenter.default.addObserver(self, selector: #selector(newDataReceived), name: NSNotification.Name(rawValue: "kDataReceived"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(messageReceived), name: NSNotification.Name(rawValue: "kMessageReceived"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(newImageReceived), name: NSNotification.Name(rawValue: "kImageReceived"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(tableTapped), name: NSNotification.Name(rawValue: "kTableTapped"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(codeOK), name: NSNotification.Name(rawValue: "kCodeOK"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let realm : String = userDefaults.string(forKey: realmKey) {
            realmLabel.text = "Realm: \(realm)"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        positionObjectsWithinSize(size: size)
        resultsTable.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    // MARK: - Custom View Methods
    
    /**
     Set up the view.
     */
    func setupView() {
        view.backgroundColor = primaryColor
        addObjects()
        positionObjectsWithinSize(size: view.bounds.size)
    }
    
    /**
     Add objects to the view.
     */
    func addObjects() {
        
        topBackground = UIImageView(image: UIImage(named: "TopBG"))
        view.addSubview(topBackground!)
        
        logoImageView = UIImageView(image: UIImage(named: "Goblin_Logo"))
        view.addSubview(logoImageView!)
        
        bottomBackground = UIImageView(image: UIImage(named: "BottomBG"))
        view.addSubview(bottomBackground!)
        
        titleImage = UIImageView(image: UIImage(named: "AATitle"))
        view.addSubview(titleImage!)
        
        objectBG = UIImageView(image: UIImage(named: "ObjectFieldBG"))
        view.addSubview(objectBG!)
        
        objectLHS = UIImageView(image: UIImage(named: "ObjectFieldLHS"))
        view.addSubview(objectLHS!)
        
        realmLabel = AALabel(textStr: "Realm: \(userDefaults.string(forKey: realmKey)!)")
        realmLabel.textAlignment = .left
        view.addSubview(realmLabel!)
        
        itemLabel = AALabel(textStr: "Item Name")
        itemLabel.textAlignment = .center
        itemLabel.backgroundColor = UIColor.clear
        itemLabel.textColor = primaryColor
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            itemLabel.font = itemLabel.font.withSize(0.8*itemLabel.font.pointSize)
        }
        
        view.addSubview(itemLabel!)
        
        itemLabelBG = UIImageView(image: UIImage(named: "ItemBGRHS"))
        view.addSubview(itemLabelBG!)
        
        maxPriceLabel = AALabel(textStr: "max price (g)")
        maxPriceLabel.font = maxPriceLabel.font.withSize(maxPriceLabel.font.pointSize/2)
        view.addSubview(maxPriceLabel!)
        
        priceBG = UIImageView(image: UIImage(named: "PriceFieldBG"))
        view.addSubview(priceBG!)
        
        objectEntry = AATextField(placeHolder: "Item Name", handler: self, selector: #selector(objectNameEntered))
        objectEntry.returnKeyType = .done
        objectEntry.textColor = primaryColor
        view.addSubview(objectEntry!)
        
        priceEntry = AATextField(placeHolder: "Gold", handler: self, selector: #selector(priceEntered))
        priceEntry.keyboardType = .numberPad
        priceEntry.attributedPlaceholder = NSAttributedString(string: priceEntry.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.gray])

        view.addSubview(priceEntry!)
        
        searchButton = AAButton(title: "Search", handler: self, selector: #selector(searchButtonTapped))
        view.addSubview(searchButton!)
        
        saveButton = AAButton(title: "Save", handler: self, selector: #selector(saveButtonTapped))
        view.addSubview(saveButton!)
        
        listButton = AAButton(title: "List", handler: self, selector: #selector(listButtonTapped))
        view.addSubview(listButton!)
        
        deleteButton = AAButton(title: "Delete", handler: self, selector: #selector(deleteButtonTapped))
        view.addSubview(deleteButton!)
        
        resultsTable = AATableView()
        setupTable()
        view.addSubview(resultsTable!)
        
        activityIndicator = UIActivityIndicatorView()
        if UIDevice.current.userInterfaceIdiom == .pad {
            activityIndicator.activityIndicatorViewStyle = .whiteLarge
        }
        view.addSubview(activityIndicator)
        
        settingsButton = AAButton(title: "", handler: self, selector: #selector(settingsButtonTapped))
        settingsButton.layer.borderWidth = 0
        view.addSubview(settingsButton)
    }
    
    func setupTable () {
        
        resultsTable.dataSource = self
        resultsTable.delegate = self
        resultsTable.rowHeight = battleIconWidth
        resultsTable.backgroundView = UIImageView(image: UIImage(named: "TableBG"))
        resultsTable.register(SearchResultCell.self, forCellReuseIdentifier: "SearchResultCell")
        resultsTable.register(SearchListCell.self, forCellReuseIdentifier: "SearchListCell")
    }
    
    /**
     Sets the size of objects separately so this function can be called from different places.
     */
    func positionObjectsWithinSize(size: CGSize) {
        
        let topMargin: CGFloat = 20.0
        let standardControlWidth: CGFloat = 200.0
        let viewHeight : CGFloat = size.height
        let viewWidth : CGFloat = size.width
        let margin: CGFloat = (viewWidth + viewHeight)/100
        let numButtons: CGFloat = 4.0
        
        var standardControlHeight: CGFloat
        if UIDevice.current.userInterfaceIdiom == .pad {
            standardControlHeight = 40.0
        } else {
            standardControlHeight = 30.0
        }
        
        var buttonWidth : CGFloat
        if standardControlWidth*numButtons > viewWidth - (numButtons + 1)*margin {
            buttonWidth = (viewWidth - (numButtons + 1)*margin)/numButtons
        } else {
            buttonWidth = standardControlWidth
        }
        
        let buttonGap = (viewWidth - numButtons*buttonWidth)/(numButtons + 1)
        
        topBackground.frame = CGRect(x: 0,
                                     y: topMargin,
                                     width: viewWidth,
                                     height: 0.2*viewHeight)
        
        let logoHeight: CGFloat = topBackground.frame.height - margin
        let logoWidth: CGFloat = logoHeight
        
        logoImageView.frame = CGRect(x: (viewWidth - logoWidth)/2,
                                     y: topMargin,
                                     width: logoWidth,
                                     height: logoHeight)
        
        let titleWidth: CGFloat = 4.86*standardControlHeight // 4.86 is the width/height ratio of the title (646/133)
        
        titleImage.frame = CGRect(x: (viewWidth - titleWidth)/2,
                                  y: topBackground.frame.maxY - standardControlHeight,
                                  width: titleWidth,
                                  height: standardControlHeight)
        
        realmLabel.frame = CGRect(x: margin,
                                  y: topBackground.frame.maxY,
                                  width: viewWidth - 2*margin,
                                  height: standardControlHeight)
        
        settingsButton.frame = realmLabel.frame
        
        objectBG.frame = CGRect(x: 0,
                                y: realmLabel.frame.maxY,
                                width: viewWidth,
                                height: standardControlHeight)
        
        objectLHS.frame = CGRect(x: 0, 
                                 y: realmLabel.frame.maxY,
                                 width: 3*standardControlHeight, // 3 = width/height
                                 height: standardControlHeight)
        
        let priceBGWidth: CGFloat = 1.8*standardControlHeight // 1.8 is the width/height ratio of the price background (76/42)
        
        priceBG.frame = CGRect(x: objectBG.frame.maxX - priceBGWidth,
                               y: realmLabel.frame.maxY,
                               width: priceBGWidth,
                               height: standardControlHeight)
        
        maxPriceLabel.frame = CGRect(x: priceBG.frame.minX,
                                     y: priceBG.frame.minY - standardControlHeight/2,
                                     width: priceBGWidth,
                                     height: standardControlHeight/3)
        
        priceEntry.frame = CGRect(x: objectBG.frame.maxX - priceBGWidth + margin,
                                  y: realmLabel.frame.maxY,
                                  width: priceBGWidth - 2*margin,
                                  height: standardControlHeight)
        
        let itemLabelWidth: CGFloat = itemLabel.intrinsicContentSize.width + 2*margin
        
        itemLabel.frame = CGRect(x: 0,
                                 y: realmLabel.frame.maxY,
                                 width: itemLabelWidth,
                                 height: standardControlHeight)
        
        let itemLabelBGWidth: CGFloat = 0.47*standardControlHeight // 0.47 is the width/height ratio of the item label background image (50/106)
        
        itemLabelBG.frame = CGRect(x: itemLabelWidth - itemLabelBGWidth,
                                 y: realmLabel.frame.maxY,
                                 width: itemLabelBGWidth,
                                 height: standardControlHeight)
        
        objectEntry.frame = CGRect(x: itemLabel.frame.maxX + margin,
                                   y: realmLabel.frame.maxY,
                                   width: viewWidth - itemLabelWidth - priceBGWidth - 2*margin,
                                   height: standardControlHeight)
        
        bottomBackground.frame = CGRect(x: 0,
                                        y: viewHeight - 2*margin - standardControlHeight,
                                        width: viewWidth,
                                        height: standardControlHeight + 2*margin)
        
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
        
        resultsTable.frame = CGRect(x: 0,
                                    y: priceEntry.frame.maxY,
                                    width: viewWidth,
                                    height: searchButton.frame.minY - priceEntry.frame.maxY - margin)
        
        activityIndicator.frame = CGRect(x: (viewWidth - standardControlHeight)/2,
                                         y: (viewHeight - standardControlHeight)/2,
                                         width: standardControlHeight,
                                         height: standardControlHeight)
    }
    
    // MARK: - Action Methods
    
    /**
     Respond to the tapping of the search button.
     Initiates the download of new data with parameters entered.
     */
    func searchButtonTapped() {
        
        if (!validItemName) {
            presentAlert(message: "Invalid item name")
            return
        }
        
        if (!readyForAction) {
            presentAlert(message: "Waiting for results of previous action")
            return
        }
        
        if let
            object : String = objectEntry.text,
            let price : String = priceEntry.text
        {
            DLog("Searching for \(object) on \(userDefaults.string(forKey: realmKey)!) with a maximum price of \(price) gold each")
            activityIndicator.startAnimating()
            API_Interface.sharedInstance.searchAuction(object: object, price: price)
            readyForAction = false
        }
    }
    
    /**
     Respond to the tapping of the save button.
     Initiates the saving of a search with parameters entered.
     */
    func saveButtonTapped() {
        
        if (!validItemName) {
            presentAlert(message: "Invalid item name")
            return
        }
        
        if (!readyForAction) {
            presentAlert(message: "Waiting for results of previous action")
            return
        }
        
        if let
            object : String = objectEntry.text,
            let price : String = priceEntry.text
        {
            DLog("Saving search for \(object) on \(userDefaults.string(forKey: realmKey)!) with a maximum price of \(price) gold each")
            API_Interface.sharedInstance.saveSearch(object: object, price: price)
            readyForAction = false
        }
    }
    
    /**
     Respond to the tapping of the list button
     Initiates the download of all current searches
     */
    func listButtonTapped() {
        
        if (!readyForAction) {
            presentAlert(message: "Waiting for results of previous action")
            return
        }
        
        activityIndicator.startAnimating()
        API_Interface.sharedInstance.listAuctions()
        readyForAction = false
    }
    
    /**
     Respond to the tapping of the delete button
     Initiates the deletion of the selected search
     */
    func deleteButtonTapped() {
        
        if (!validItemName) {
            presentAlert(message: "Invalid item name")
            return
        }
        
        if (!readyForAction) {
            presentAlert(message: "Waiting for results of previous action")
            return
        }

        if let
            object : String = objectEntry.text,
            let price : String = priceEntry.text
        {
            DLog("Deleting search for \(object) on \(userDefaults.string(forKey: realmKey)!) with a maximum price of \(price) gold each")
            activityIndicator.startAnimating()
            API_Interface.sharedInstance.deleteAuction(object: object, price: price)
            readyForAction = false
        }
    }
    
    /**
     Respond to the tapping of the delete button
     Initiates the deletion of the selected search
     */
    func settingsButtonTapped() {
        
        let settingsVC : SettingsVC = SettingsVC()
        present(settingsVC, animated: true, completion: nil)
    }
    
    /**
     Called after user edits the object name text field
     */
    func objectNameEntered() {

        validItemName = false
        objectEntry.resignFirstResponder()
        
        if let objectName: String = objectEntry.text {
            if !objectName.isEmpty {
                API_Interface.sharedInstance.checkCode(object: objectName)
            }
        }
    }
    
    /**
     Called after user edits the price text field
     */
    func priceEntered() {
        
        priceEntry.resignFirstResponder()
        
        if let priceStr : String = priceEntry.text {
            if let _ : Int = Int(priceStr) {
                // price is int
            } else {
                if !priceStr.isEmpty {
                    presentAlert(message: "Price needs to be in whole units of gold")
                }
            }
        }
    }
    
    /**
     Called when the table is tapped
     */
    func tableTapped() {
        
        DispatchQueue.main.async {
            self.view.endEditing(true)
        }
    }
    
    /**
     A handler for a UIAlertAction which dismisses the alert.
     Resets the flag indicating an alert is currently presented.
     
     - parameter alert: The UIAlertAction
     */
    func alertDismissed(alert: UIAlertAction!) {
        presentingAlert = false
    }
    
    // MARK: - Notification Methods
    
    /**
     Called when notification of new data download completion is received
     Reloads the table and stops the activity indicator
     */
    func newDataReceived() {
        DLog("Received: \(DataHandler.sharedInstance.searchResults.count) objects")
        DispatchQueue.main.async {
            self.resultsTable!.reloadData()
            self.activityIndicator.stopAnimating()
        }
        readyForAction = true
    }
    
    /**
     Called when notification of message is received
     
     - parameter notification: The notification
     */
    func messageReceived(notification: Notification) {
        if let message : String = (notification as NSNotification).userInfo?["message"] as? String {
            DLog("Received message: \(message)")
            
            if message.contains("Saved search") || message.contains("Search deleted") {
                API_Interface.sharedInstance.listAuctions()
            }
            
            else if message.contains("No searches") && DataHandler.sharedInstance.searchResults.count == 1 {
                DataHandler.sharedInstance.searchResults.removeAll()
                DispatchQueue.main.async {
                    self.resultsTable!.reloadData()
                }
                readyForAction = true
            }
            
            else if message.contains("Unknown Object") {
                validItemName = false
            }
                
            else if message.contains("Nothing found") {
                readyForAction = true
            }
            
            DispatchQueue.main.async {
                self.presentAlert(message: message)
            }
        }
        
        else {
            DLog("Couldn't extract message from notification")
        }
        
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
    
    /**
     Called when notification of new icon image download completion is received.
     Reloads the table.
     */
    func newImageReceived() {
        if DataHandler.sharedInstance.searchResults.count > 0 {
            DispatchQueue.main.async {
                self.resultsTable!.reloadData()
            }
        }
    }
    
    /**
     Called when a notification has been recieved that an item code has been returned for an item name entered into the object field.
     */
    func codeOK() {
        validItemName = true
    }
    
    // MARK: - Custom Methods
    
    /**
     Presents an alert to the user
     
     - parameter message: The message to present to the user
     */
    func presentAlert (message: String) {
        if presentingAlert == false {
            let alert = UIAlertController(title: "Auction Alert", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: alertDismissed)
            alert.addAction(action)
            presentingAlert = true
            present(alert, animated: true, completion: nil)
        } else {
            DLog("Already presenting alert")
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataHandler.sharedInstance.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let singleResult: Dictionary<String, AnyObject> = DataHandler.sharedInstance.searchResults[(indexPath as NSIndexPath).row]
        
        if let quantity : Int = singleResult["quantity"] as? Int {
            let cell : SearchResultCell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as! SearchResultCell
            
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
            
            cell.detailLabel!.text = "Seller: \(owner ?? "")"
            
            if UIDevice.current.userInterfaceIdiom == .phone {
                cell.bidLabel!.text = "Current bid:\n\(bidString)"
                cell.buyoutLabel!.text = "Buyout:\n\(buyoutString)"
            } else {
                cell.bidLabel!.text = "Current bid: \(bidString)"
                cell.buyoutLabel!.text = "Buyout: \(buyoutString)"
            }
            
            if let code : Int = singleResult["item"] as? Int {
                cell.iconImage.image = ImageFetcher.sharedInstance.imageFromCode(code: String(code))
            }
            
            cell.stackSizeLabel.text = String(quantity)
            
            return cell
        } else if let realm : String = singleResult["realm"] as? String {
            let cell : SearchListCell = tableView.dequeueReusableCell(withIdentifier: "SearchListCell", for: indexPath) as! SearchListCell
            
            let object : String? = singleResult["object"] as? String
            
            var priceString : String = ""
            if let price : Int = singleResult["price"] as? Int {
                let (priceGold, priceSilver, priceCopper) = ConvertMoney(price*10000)
                priceString = "\(priceGold)g \(priceSilver)s \(priceCopper)c"
            }
            
            cell.detailLabel!.text = "Search for \(object ?? "") on \(realm ) with a minimum price of \(priceString)"
            
            return cell
        } else {
            DLog("Cannot interpret data")
            let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
            return cell
        }
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let singleResult: Dictionary<String, AnyObject> = DataHandler.sharedInstance.searchResults[(indexPath as NSIndexPath).row]
        
        if let realm: String = singleResult["realm"] as? String {
            userDefaults.set(realm.capitalized, forKey: realmKey)
            realmLabel.text = "Realm: \(realm.capitalized)"
            
            if let object: String = singleResult["object"] as? String {
                objectEntry.text = object
                validItemName = true
            }
            
            if let price: Int = singleResult["price"] as? Int {
                priceEntry.text = price.description
            }
            
            if let locale: String = singleResult["locale"] as? String {
                userDefaults.set(locale, forKey: localeKey)
                
                switch locale {
                case "en_GB":
                    userDefaults.set("EU", forKey: regionKey)
                    userDefaults.set("en", forKey: languageKey)
                case "de_DE":
                    userDefaults.set("EU", forKey: regionKey)
                    userDefaults.set("de", forKey: languageKey)
                case "es_ES":
                    userDefaults.set("EU", forKey: regionKey)
                    userDefaults.set("es", forKey: languageKey)
                case "fr_FR":
                    userDefaults.set("EU", forKey: regionKey)
                    userDefaults.set("fr", forKey: languageKey)
                case "it_IT":
                    userDefaults.set("EU", forKey: regionKey)
                    userDefaults.set("it", forKey: languageKey)
                case "pt_PT":
                    userDefaults.set("EU", forKey: regionKey)
                    userDefaults.set("pt", forKey: languageKey)
                case "ru_RU":
                    userDefaults.set("EU", forKey: regionKey)
                    userDefaults.set("ru", forKey: languageKey)
                case "en_US":
                    userDefaults.set("US", forKey: regionKey)
                    userDefaults.set("en", forKey: languageKey)
                case "es_MX":
                    userDefaults.set("US", forKey: regionKey)
                    userDefaults.set("es", forKey: languageKey)
                case "pt_BR":
                    userDefaults.set("US", forKey: regionKey)
                    userDefaults.set("pt", forKey: languageKey)
                case "zh_CN":
                    userDefaults.set("CN", forKey: regionKey)
                    userDefaults.set("zh", forKey: languageKey)
                case "ko_KR":
                    userDefaults.set("KR", forKey: regionKey)
                    userDefaults.set("ko", forKey: languageKey)
                case "zh_TW":
                    userDefaults.set("TW", forKey: regionKey)
                    userDefaults.set("zh", forKey: languageKey)
                default:
                    userDefaults.set("EU", forKey: regionKey)
                    userDefaults.set("en", forKey: languageKey)
                }
            }
        }
    }
}
