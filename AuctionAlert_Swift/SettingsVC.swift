//
//  SettingsVC.swift
//  AuctionAlert_Swift
//
//  Created by Robin Spinks on 28/07/2016.
//  Copyright © 2016 UglyBlueCat. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
    
    var doneButton: AAButton!
    var regionLabel: AALabel!
    var localeLabel: AALabel!
    var realmLabel: AALabel!
    var regionControl: AASegmentedControl!
    var languageControl: AASegmentedControl!
    var realmSpinner: UIPickerView!
    let regions: Array = ["EU", "US", "CN", "KR", "TW"]
    let languages: Array = ["en", "de", "es", "fr", "it", "pt", "ru", "ko", "zh"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        positionObjectsWithinSize(size)
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
        setLanguages()
    }
    
    /*
     * addObjects()
     *
     * Add objects to the view
     */
    func addObjects() {
        regionLabel = AALabel(textStr: "Region")
        view.addSubview(regionLabel)
        
        regionControl = AASegmentedControl(items: regions, handler: self, selector: #selector(regionSegmentTapped))
        regionControl.selectedSegmentIndex = regions.indexOf(userDefaults.stringForKey("kRegion")!)!
        view.addSubview(regionControl)
        
        localeLabel = AALabel(textStr: "Language")
        view.addSubview(localeLabel)
        
        languageControl = AASegmentedControl(items: languages, handler: self, selector: #selector(languageSegmentTapped))
        languageControl.selectedSegmentIndex = languages.indexOf(userDefaults.stringForKey("kLanguage")!)!
        view.addSubview(languageControl)
        
        realmLabel = AALabel(textStr: "Realm")
        view.addSubview(realmLabel)
        
        realmSpinner = UIPickerView()
        view.addSubview(realmSpinner)
        
        doneButton = AAButton(title: "Done", handler: self, selector: #selector(doneButtonTapped))
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
        
        let doneButtonFrame: CGRect = CGRect(x: (viewWidth - standardControlWidth)/2,
                                             y: viewHeight - standardControlHeight - margin,
                                             width: standardControlWidth,
                                             height: standardControlHeight)
        doneButton.frame = doneButtonFrame
        
        let regionLabelFrame: CGRect = CGRect(x: margin,
                                             y: topMargin,
                                             width: viewWidth - 2*margin,
                                             height: standardControlHeight)
        regionLabel.frame = regionLabelFrame
        
        let regionControlFrame: CGRect = CGRect(x: margin,
                                             y: CGRectGetMaxY(regionLabelFrame) + margin,
                                             width: viewWidth - 2*margin,
                                             height: standardControlHeight)
        regionControl.frame = regionControlFrame
        
        let localeLabelFrame: CGRect = CGRect(x: margin,
                                             y: CGRectGetMaxY(regionControlFrame) + margin,
                                             width: viewWidth - 2*margin,
                                             height: standardControlHeight)
        localeLabel.frame = localeLabelFrame
        
        let languageControlFrame: CGRect = CGRect(x: margin,
                                             y: CGRectGetMaxY(localeLabelFrame) + margin,
                                             width: viewWidth - 2*margin,
                                             height: standardControlHeight)
        languageControl.frame = languageControlFrame
        
        let realmLabelFrame: CGRect = CGRect(x: margin,
                                             y: CGRectGetMaxY(languageControlFrame) + margin,
                                             width: viewWidth - 2*margin,
                                             height: standardControlHeight)
        realmLabel.frame = realmLabelFrame
        
        let realmSpinnerFrame: CGRect = CGRect(x: margin,
                                             y: CGRectGetMaxY(realmLabelFrame) + margin,
                                             width: viewWidth - 2*margin,
                                             height: CGRectGetMinY(doneButtonFrame) - CGRectGetMaxY(realmLabelFrame) - 2*margin)
        realmSpinner.frame = realmSpinnerFrame
    }
    
    /*
     * doneButtonTapped()
     *
     * Respond to the tapping of the done button
     * Checks all settings are saved and removes the view
     */
    func doneButtonTapped() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
     * regionSegmentTapped()
     *
     * Respond to the tapping of a segment on the region segmented control
     */
    func regionSegmentTapped() {
        userDefaults.setValue(regions[regionControl.selectedSegmentIndex], forKey: "kRegion")
        setLanguages()
        setLocale()
    }
    
    /*
     * languageSegmentTapped()
     *
     * Respond to the tapping of a segment on the language segmented control
     */
    func languageSegmentTapped() {
        userDefaults.setValue(languages[languageControl.selectedSegmentIndex], forKey: "kLanguage")
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
            languageControl.setEnabled(true, forSegmentAtIndex: 8)
            languageControl.selectedSegmentIndex = 8
        case 3:
            languageControl.setEnabled(true, forSegmentAtIndex: 7)
            languageControl.selectedSegmentIndex = 7
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
                userDefaults.setValue("en_GB", forKey: "kLocale")
            case 1:
                userDefaults.setValue("de_DE", forKey: "kLocale")
            case 2:
                userDefaults.setValue("es_ES", forKey: "kLocale")
            case 3:
                userDefaults.setValue("fr_FR", forKey: "kLocale")
            case 4:
                userDefaults.setValue("it_IT", forKey: "kLocale")
            case 5:
                userDefaults.setValue("pt_PT", forKey: "kLocale")
            case 6:
                userDefaults.setValue("ru_RU", forKey: "kLocale")
            default:
                presentAlert("Language \(languages[languageControl.selectedSegmentIndex]) invalid for region \(regions[regionControl.selectedSegmentIndex])")
            }
        case 1:
            switch languageControl.selectedSegmentIndex {
            case 0:
                userDefaults.setValue("en_US", forKey: "kLocale")
            case 2:
                userDefaults.setValue("es_MX", forKey: "kLocale")
            case 5:
                userDefaults.setValue("pt_BR", forKey: "kLocale")
            default:
                presentAlert("Language \(languages[languageControl.selectedSegmentIndex]) invalid for region \(regions[regionControl.selectedSegmentIndex])")
            }
        case 2:
            userDefaults.setValue("zh_CN", forKey: "kLocale")
        case 3:
            userDefaults.setValue("ko_KR", forKey: "kLocale")
        case 4:
            userDefaults.setValue("zh_TW", forKey: "kLocale")
        default:
            DLog("No region selected")
        }
    }
}
