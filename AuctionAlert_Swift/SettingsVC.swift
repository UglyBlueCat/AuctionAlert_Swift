//
//  SettingsVC.swift
//  AuctionAlert_Swift
//
//  Created by Robin Spinks on 28/07/2016.
//  Copyright © 2016 UglyBlueCat. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
    
    var backgroundImage: UIImageView!
    var doneButton: AAButton!
    var regionLabel: AALabel!
    var localeLabel: AALabel!
    var realmLabel: AALabel!
    var regionControl: AASegmentedControl!
    var languageControl: AASegmentedControl!
    var realmSpinner: UIPickerView!
    let regions: Array = ["EU", "US", "KR", "TW"] //, "CN"] currently unsupported by battle.net
    let languages: Array = ["en", "de", "es", "fr", "it", "pt", "ru", "ko", "zh"]
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(newRealmsReceived), name: "kRealmsReceived", object: nil)
        API_Interface.sharedInstance.fetchRealmData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        positionObjectsWithinSize(size)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    
    // MARK: - Custom Methods
    
    /*
     * setupView()
     *
     * Set up the view
     */
    func setupView() {
        view.backgroundColor = primaryColor
        addObjects()
        positionObjectsWithinSize(view.bounds.size)
        setLanguages()
    }
    
    /*
     * addObjects()
     *
     * Add objects to the view
     */
    func addObjects() {
        
        backgroundImage = UIImageView(image: UIImage(named: "MainBG.jpg"))
        view.addSubview(backgroundImage)
        
        regionLabel = AALabel(textStr: "Region")
        regionLabel.textColor = secondaryTextColor
        view.addSubview(regionLabel)
        
        regionControl = AASegmentedControl(items: regions, handler: self, selector: #selector(regionSegmentTapped))
        regionControl.selectedSegmentIndex = regions.indexOf(userDefaults.stringForKey(regionKey)!)!
        view.addSubview(regionControl)
        
        localeLabel = AALabel(textStr: "Language")
        localeLabel.textColor = secondaryTextColor
        view.addSubview(localeLabel)
        
        languageControl = AASegmentedControl(items: languages, handler: self, selector: #selector(languageSegmentTapped))
        languageControl.selectedSegmentIndex = languages.indexOf(userDefaults.stringForKey(languageKey)!)!
        view.addSubview(languageControl)
        
        realmLabel = AALabel(textStr: "Realm")
        realmLabel.textColor = secondaryTextColor
        view.addSubview(realmLabel)
        
        realmSpinner = UIPickerView()
        realmSpinner.delegate = self
        realmSpinner.dataSource = self
        realmSpinner.tintColor = secondaryTextColor
        view.addSubview(realmSpinner)
        
        doneButton = AAButton(title: "Done", handler: self, selector: #selector(doneButtonTapped))
        doneButton.setTitleColor(secondaryTextColor, forState: .Normal)
        doneButton.layer.borderColor = secondaryTextColor.CGColor
        view.addSubview(doneButton!)
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
        
        backgroundImage.frame = CGRect(x: 0, 
                                       y: 0, 
                                       width: viewWidth, 
                                       height: viewHeight)
        
        doneButton.frame = CGRect(x: (viewWidth - standardControlWidth)/2,
                                  y: viewHeight - standardControlHeight - margin,
                                  width: standardControlWidth,
                                  height: standardControlHeight)
        
        regionLabel.frame = CGRect(x: margin,
                                   y: topMargin,
                                   width: viewWidth - 2*margin,
                                   height: standardControlHeight)
        
        regionControl.frame = CGRect(x: margin,
                                     y: CGRectGetMaxY(regionLabel.frame) + margin,
                                     width: viewWidth - 2*margin,
                                     height: standardControlHeight)
        
        localeLabel.frame = CGRect(x: margin,
                                   y: CGRectGetMaxY(regionControl.frame) + margin,
                                   width: viewWidth - 2*margin,
                                   height: standardControlHeight)
        
        languageControl.frame = CGRect(x: margin,
                                       y: CGRectGetMaxY(localeLabel.frame) + margin,
                                       width: viewWidth - 2*margin,
                                       height: standardControlHeight)
        
        realmLabel.frame = CGRect(x: margin,
                                  y: CGRectGetMaxY(languageControl.frame) + margin,
                                  width: viewWidth - 2*margin,
                                  height: standardControlHeight)
        
        realmSpinner.frame = CGRect(x: margin,
                                    y: CGRectGetMaxY(realmLabel.frame) + margin,
                                    width: viewWidth - 2*margin,
                                    height: CGRectGetMinY(doneButton.frame) - CGRectGetMaxY(realmLabel.frame) - 2*margin)
    }
    
    /*
     * doneButtonTapped()
     *
     * Respond to the tapping of the done button
     * Checks all settings are saved and removes the view
     */
    func doneButtonTapped() {
        userDefaults.setValue(regions[regionControl.selectedSegmentIndex], forKey: regionKey)
        userDefaults.setValue(languages[languageControl.selectedSegmentIndex], forKey: languageKey)
        userDefaults.setObject(DataHandler.sharedInstance.realmList[realmSpinner.selectedRowInComponent(0)], forKey: realmKey)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
     * regionSegmentTapped()
     *
     * Respond to the tapping of a segment on the region segmented control
     */
    func regionSegmentTapped() {
        userDefaults.setValue(regions[regionControl.selectedSegmentIndex], forKey: regionKey)
        setLanguages()
        setLocale()
    }
    
    /*
     * languageSegmentTapped()
     *
     * Respond to the tapping of a segment on the language segmented control
     */
    func languageSegmentTapped() {
        userDefaults.setValue(languages[languageControl.selectedSegmentIndex], forKey: languageKey)
        setLocale()
    }
    
    /*
     * setLanguages()
     *
     * Sets the availability of languages on the language segmented control depending on region
     */
    func setLanguages() {
        let currentSelectedIndex = languageControl.selectedSegmentIndex
        
        for i in 0..<languageControl.numberOfSegments {
            languageControl.setEnabled(false, forSegmentAtIndex: i)
        }

        switch regionControl.selectedSegmentIndex {
        case 0:
            for j in 0..<7 {
                languageControl.setEnabled(true, forSegmentAtIndex: j)
            }
            if currentSelectedIndex > 6 {
                languageControl.selectedSegmentIndex = 0
            } else {
                languageControl.selectedSegmentIndex = currentSelectedIndex
            }
        case 1:
            languageControl.setEnabled(true, forSegmentAtIndex: 0)
            languageControl.setEnabled(true, forSegmentAtIndex: 2)
            languageControl.setEnabled(true, forSegmentAtIndex: 5)
            
            if currentSelectedIndex != 0 &&
                currentSelectedIndex != 2 &&
                currentSelectedIndex != 5 {
                languageControl.selectedSegmentIndex = 0
            } else {
                languageControl.selectedSegmentIndex = currentSelectedIndex
            }
        case 2:
            languageControl.setEnabled(true, forSegmentAtIndex: 7)
            languageControl.selectedSegmentIndex = 7
        case 3:
            languageControl.setEnabled(true, forSegmentAtIndex: 8)
            languageControl.selectedSegmentIndex = 8
        case 4:
            languageControl.setEnabled(true, forSegmentAtIndex: 8)
            languageControl.selectedSegmentIndex = 8
        default:
            DLog("No region selected")
        }
    }
    
    /*
     * setLocale()
     *
     * Sets the locale from the region and language
     */
    func setLocale() {
        switch regionControl.selectedSegmentIndex {
        case 0:
            switch languageControl.selectedSegmentIndex {
            case 0:
                userDefaults.setValue("en_GB", forKey: localeKey)
            case 1:
                userDefaults.setValue("de_DE", forKey: localeKey)
            case 2:
                userDefaults.setValue("es_ES", forKey: localeKey)
            case 3:
                userDefaults.setValue("fr_FR", forKey: localeKey)
            case 4:
                userDefaults.setValue("it_IT", forKey: localeKey)
            case 5:
                userDefaults.setValue("pt_PT", forKey: localeKey)
            case 6:
                userDefaults.setValue("ru_RU", forKey: localeKey)
            default:
                DLog("Language \(languages[languageControl.selectedSegmentIndex]) invalid for region \(regions[regionControl.selectedSegmentIndex])")
            }
        case 1:
            switch languageControl.selectedSegmentIndex {
            case 0:
                userDefaults.setValue("en_US", forKey: localeKey)
            case 2:
                userDefaults.setValue("es_MX", forKey: localeKey)
            case 5:
                userDefaults.setValue("pt_BR", forKey: localeKey)
            default:
                DLog("Language \(languages[languageControl.selectedSegmentIndex]) invalid for region \(regions[regionControl.selectedSegmentIndex])")
            }
        case 2:
            userDefaults.setValue("ko_KR", forKey: localeKey)
        case 3:
            userDefaults.setValue("zh_TW", forKey: localeKey)
        case 4:
            userDefaults.setValue("zh_CN", forKey: localeKey)
        default:
            DLog("No region selected")
        }
        API_Interface.sharedInstance.fetchRealmData()
    }
    
    /*
     * newRealmsReceived
     *
     * Responds to a new realms notification
     * Reloads realms spinner with fresh data
     */
    func newRealmsReceived () {
        realmSpinner.reloadAllComponents()
        if let realm : String = userDefaults.stringForKey(realmKey) {
            if let index : Int = DataHandler.sharedInstance.realmList.indexOf(realm) {
                realmSpinner.selectRow(index, inComponent: 0, animated: true)
            }
        }
    }
}

extension SettingsVC: UIPickerViewDelegate {
    
    func pickerView(pickerView: UIPickerView,
                               titleForRow row: Int,
                                           forComponent component: Int) -> String? {
        var realm : String!
        if DataHandler.sharedInstance.realmList.count > (row + 1) {
            realm = DataHandler.sharedInstance.realmList[row]
        }
        return realm
    }
    
    func pickerView(pickerView: UIPickerView,
                               didSelectRow row: Int,
                                            inComponent component: Int) {
        var realm : String!
        if DataHandler.sharedInstance.realmList.count > (row + 1) {
            realm = DataHandler.sharedInstance.realmList[row]
        }
        userDefaults.setObject(realm, forKey: realmKey)
    }
}

extension SettingsVC: UIPickerViewDataSource {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView,
                      numberOfRowsInComponent component: Int) -> Int {
        return DataHandler.sharedInstance.realmList.count - 1
    }
}
