//
//  SpeedSettings.swift
//  Download-It
//
//  Created by Justin Carver on 9/28/16.
//  Copyright © 2016 Justin Carver. All rights reserved.
//

import UIKit

class SpeedSettings: UIViewController, UITextFieldDelegate {
    
    static let sharedContoller = SpeedSettings()
    
    private let kSettings = "Settings"
    
    var settings: Settings?
    
    @IBOutlet weak var wifiMaxTextField: UITextField!
    @IBOutlet weak var wifiMinTextField: UITextField!
    @IBOutlet weak var ethernetMaxTextField: UITextField!
    @IBOutlet weak var ethernetMinTetField: UITextField!
    
    @IBAction func screenTapped(sender: UITapGestureRecognizer) {
        wifiMaxTextField.resignFirstResponder()
        wifiMinTextField.resignFirstResponder()
        ethernetMinTetField.resignFirstResponder()
        ethernetMaxTextField.resignFirstResponder()
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func doneButtonTapped(sender: UIBarButtonItem) {
        
        guard let wifiMax = wifiMaxTextField.text, let wifiMin = wifiMinTextField.text, let etherMax = wifiMaxTextField.text, etherMin = ethernetMinTetField.text else {
            presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            return
        }
        
        guard wifiMax != "" && wifiMin != "" && etherMax != "" && etherMax != "" else { presentingViewController?.dismissViewControllerAnimated(true, completion: nil); return }
        
        settings = Settings(maxWifi: Double(wifiMax)!, minWifi: Double(wifiMin)!, minEther: Double(etherMin)!, maxEther: Double(etherMax)!)
        
        NSUserDefaults.standardUserDefaults().setObject(settings?.dictionaryRep, forKey: kSettings)
    
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loadFromPersistStore() {
        guard let setting = NSUserDefaults.standardUserDefaults().objectForKey(kSettings) as? [String: Double] else {
            return
        }
        settings = Settings(dictionary: setting)
    }
    
    func setupTextField() {
        guard let setting = settings else { wifiMinTextField.placeholder = ""; wifiMaxTextField.placeholder = ""; ethernetMaxTextField.placeholder = ""; ethernetMinTetField.placeholder = ""; return }
        wifiMaxTextField.placeholder = "\(setting.maxWifi)"
        wifiMinTextField.placeholder = "\(setting.minWifi)"
        ethernetMinTetField.placeholder = "\(setting.minEther)"
        ethernetMaxTextField.placeholder = "\(setting.maxWifi)"
    }
    
    override func viewWillAppear(animated: Bool) {
        loadFromPersistStore()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFromPersistStore()
        setupTextField()
    }
}
