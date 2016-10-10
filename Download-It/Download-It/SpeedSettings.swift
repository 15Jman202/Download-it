//
//  SpeedSettings.swift
//  Download-It
//
//  Created by Justin Carver on 9/28/16.
//  Copyright © 2016 Justin Carver. All rights reserved.
//

import UIKit

class SpeedSettings: UIViewController, UITextFieldDelegate {
    
    // MARK: - Keys
    
    private let kSettings = "Settings"
    
    // MARK: - Accessable functions
    
    static let sharedContoller = SpeedSettings()
    var settings: Settings?
    
    // MARK: - View
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadFromPersistStore()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wifiMaxTextField.delegate = self
        wifiMinTextField.delegate = self
        ethernetMinTetField.delegate = self
        ethernetMaxTextField.delegate = self
        loadFromPersistStore()
        setupTextField()
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var wifiMaxTextField: UITextField!
    @IBOutlet weak var wifiMinTextField: UITextField!
    @IBOutlet weak var ethernetMaxTextField: UITextField!
    @IBOutlet weak var ethernetMinTetField: UITextField!
    
    // MARK: - Actions
    
    @IBAction func screenTapped(sender: UITapGestureRecognizer) {
        wifiMaxTextField.resignFirstResponder()
        wifiMinTextField.resignFirstResponder()
        ethernetMinTetField.resignFirstResponder()
        ethernetMaxTextField.resignFirstResponder()
    }
    
    @IBAction func doneButtonTapped(sender: UIBarButtonItem) {
        
        guard let wifiMax = wifiMaxTextField.text, let wifiMin = wifiMinTextField.text, let etherMax = ethernetMaxTextField.text, let etherMin = ethernetMinTetField.text else {
            presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            return
        }
        
        guard wifiMax != "" && wifiMin != "" && etherMax != "" && etherMin != "" else {
            if settings == nil {
                presentUnsavedSettings()
            } else {
                presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                return
            }
            return
        }
        
        guard CalculatorController.sharedController.findAverageSpeed(Double(wifiMin)!, max: Double(wifiMax)!) > 0.0 && CalculatorController.sharedController.findAverageSpeed(Double(etherMin)!, max: Double(etherMax)!) > 0.0 else { presentAverageZeroController(); return }
        
        settings = Settings(maxWifi: Double(wifiMax)!, minWifi: Double(wifiMin)!, minEther: Double(etherMin)!, maxEther: Double(etherMax)!)
        
        NSUserDefaults.standardUserDefaults().setObject(settings?.dictionaryRep, forKey: kSettings)
    
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func dontCareAboutEther() {
        ethernetMinTetField.text = "0.0"
        ethernetMaxTextField.text = "0.1"
        minEthernetEditingEnded()
        maxEthernetEditingEnded()
    }
    
    // MARK: - Alert Controllers
    
    func presentUnsavedSettings() {
        let alertController = UIAlertController(title: "If you leave now your savings will be deleted", message: "Are you sure you would like to leave this page?", preferredStyle: .Alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .Default) { (action) in
            self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "No", style: .Cancel, handler: nil)
        
        alertController.addAction(yesAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func presentAverageZeroController() {
        let alertController = UIAlertController(title: "Average download speeds must be above 0.0 Mbps", message: "Please reinput your download settings", preferredStyle: .Alert)
        
        let dismissAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
        alertController.addAction(dismissAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if string == "\n" || string == "\t" {
            return false
        }
        
        let nonValue = NSCharacterSet(charactersInString: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz\"\"`~<>\\/?';:{}[]|=+-_()*&^%$#@!,")
        
        return (string.rangeOfCharacterFromSet(nonValue) == nil)
    }

    
    // MARK: - Setup Functions
    
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
        ethernetMaxTextField.placeholder = "\(setting.maxEther)"
    }
    
    // MARK: - End Editing Fucntions
    
    @IBAction func minWifiEditingEnded() {
        if let settings = settings where wifiMinTextField.text != ""{
            let minWifi = Double(wifiMinTextField.text ?? "")!
            settings.minWifi = minWifi
            NSUserDefaults.standardUserDefaults().setObject(settings.dictionaryRep, forKey: kSettings)
        }
    }
    
    @IBAction func maxWifiEditingEnded() {
        if let settings = settings where wifiMaxTextField.text != ""{
            let maxWifi = Double(wifiMaxTextField.text ?? "")!
            settings.maxWifi = maxWifi
            NSUserDefaults.standardUserDefaults().setObject(settings.dictionaryRep, forKey: kSettings)
        }
    }
    
    @IBAction func minEthernetEditingEnded() {
        if let settings = settings where ethernetMinTetField.text != "" {
            let minEthernet = Double(ethernetMinTetField.text ?? "")!
            settings.minEther = minEthernet
            NSUserDefaults.standardUserDefaults().setObject(settings.dictionaryRep, forKey: kSettings)
        }
    }
    
    @IBAction func maxEthernetEditingEnded() {
        if let settings = settings where ethernetMaxTextField.text != "" {
            let etherMax = Double(ethernetMaxTextField.text ?? "")!
            settings.maxEther = etherMax
            NSUserDefaults.standardUserDefaults().setObject(settings.dictionaryRep, forKey: kSettings)
        }
    }
}
