//
//  MainScreen.swift
//  Download-It
//
//  Created by Justin Carver on 9/28/16.
//  Copyright © 2016 Justin Carver. All rights reserved.
//

import UIKit

class MainScreen: UIViewController, UITextFieldDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var seperationLine: UILabel!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var sizeLabel: UILabel!
    
    @IBOutlet weak var sizeOfFileTextField: UITextField!
    
    // MARK: - Accessable Fucntions
    
    var file = File()
    
    // MARK: - View
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        SpeedSettings.sharedContoller.loadFromPersistStore()
        sizeOfTextFieldDidChange()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        averageLabel.text = ""
        maxLabel.text = ""
        minLabel.text = ""
        sizeOfFileTextField.delegate = self
    }
    
    // MARK: - Actions
  
    @IBAction func sizeOfTextFieldDidChange() {
        
        guard let text = sizeOfFileTextField.text where text != "" && text != " " else { return }
        
        guard text.characters.first != "." else { return }
        guard text.characters.count <= 15 else { sizeOfFileTextField.text = ""; file.size = 0.0; file.isPluggedIn = false; file.sizeType = Size.MB; displayToLargeOfFileAlert(); return }
        
        file.size = Double(text)!
        
        updateTextFields()
    }

    @IBAction func screenTapped(sender: UITapGestureRecognizer) {
        
        sizeOfFileTextField.resignFirstResponder()
        
        guard let text = sizeOfFileTextField.text where text != "" else { return }
        
        guard text.characters.first != "." else { return }
        guard text.characters.count <= 15 else { sizeOfFileTextField.text = ""; file.size = 0.0; file.isPluggedIn = false; file.sizeType = Size.MB; displayToLargeOfFileAlert(); return }
        
        file.size = Double(text)!
        
        updateTextFields()
    }
    
    // MARK: - Switch and Stepper functions
    
    @IBAction func wifiEthernetSwitch(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            file.isPluggedIn = false
            updateTextFields()
        } else {
            file.isPluggedIn = true
            updateTextFields()
        }
    }
    
    @IBAction func valueChanged(sender: UIStepper) {
        switch sender.value {
        case 0:
            file.sizeType = Size.KB
            sizeLabel.text = "\(Size.KB)"
            updateTextFields()
        case 1:
            file.sizeType = Size.MB
            sizeLabel.text = "\(Size.MB)"
            updateTextFields()
        case 2:
            file.sizeType = Size.GB
            sizeLabel.text = "\(Size.GB)"
            updateTextFields()
        case 3:
            file.sizeType = Size.TB
            sizeLabel.text = "\(Size.TB)"
            updateTextFields()
        default:
            print("Error: NO TYPE")
        }
    }
    
    // MARK: - Alert Controllers
    
    func displaySettingsAlert() {
        let alertController = UIAlertController(title: "Please setup your speed settings", message: nil, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func displayToLargeOfFileAlert() {
        let alertController = UIAlertController(title: "Size of file is to large to calculate", message: nil, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Helper functions
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if string == "\n" || string == "\t" {
            return false
        }
        
        if string == "." {
            return (!(textField.text?.characters.contains(".") ?? true))
        }
        
        let nonValue = NSCharacterSet(charactersInString: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz\"\"`~<>\\/?';:{}[]|=+-_()*&^%$#@!,")
        
        return (string.rangeOfCharacterFromSet(nonValue) == nil)
    }
    
    func updateTextFields() {
        
        guard let settings = SpeedSettings.sharedContoller.settings else {
            displaySettingsAlert()
            return
        }
        
        if file.isPluggedIn == false {
            
            let averageSpeed = CalculatorController.sharedController.findAverageSpeed(settings.minWifi, max: settings.maxWifi)
            let averageTime = CalculatorController.sharedController.findTimeFrom(averageSpeed, sizeOfFile: file.size, typeOfSize: file.sizeType)
            let maxTime = CalculatorController.sharedController.findTimeFrom(settings.maxWifi, sizeOfFile: file.size, typeOfSize: file.sizeType)
            let minTime = CalculatorController.sharedController.findTimeFrom(settings.minWifi, sizeOfFile: file.size, typeOfSize: file.sizeType)

            let averageHours = averageTime.0
            let averageMins = averageTime.1
            let averageSecs = averageTime.2
            
            let maxHours = maxTime.0
            let maxMins = maxTime.1
            let maxSecs = maxTime.2
            
            let minHours = minTime.0
            let minMins = minTime.1
            let minSecs = minTime.2
            
            if averageHours == 0 && averageMins == 0 && averageSecs == 0 {
                averageLabel.text = "Time is to short to calculate"
            } else if Double(averageHours) > 99999.0 {
                averageLabel.text = "Time is to long to calculate"
            } else {
                averageLabel.text = "Hours: \(averageHours), Minutes: \(averageMins), Seconds: \(averageSecs)"
            }
            
            if maxHours == 0 && maxMins == 0 && maxSecs == 0 {
                minLabel.text = "Time is to small to calculate"
            } else if Double(maxHours) > 99999.0 {
                minLabel.text = "Time is to long to calculate"
            } else {
                minLabel.text = "Hours: \(maxHours), Minutes: \(maxMins), Seconds: \(maxSecs)"
            }
            
            if minHours == 0 && minMins == 0 && minSecs == 0 {
                maxLabel.text = "Time is to small to calculate"
            } else if Double(minHours) > 99999.0 {
                maxLabel.text = "Time is to long to calculate"
            } else {
                maxLabel.text = "Hours: \(minHours), Minutes: \(minMins), Seconds: \(minSecs)"
            }
            
        } else {
            
            let averageSpeed = CalculatorController.sharedController.findAverageSpeed(settings.minEther, max: settings.maxEther)
            let averageTime = CalculatorController.sharedController.findTimeFrom(averageSpeed, sizeOfFile: file.size, typeOfSize: file.sizeType)
            let maxTime = CalculatorController.sharedController.findTimeFrom(settings.maxEther, sizeOfFile: file.size, typeOfSize: file.sizeType)
            let minTime = CalculatorController.sharedController.findTimeFrom(settings.minEther, sizeOfFile: file.size, typeOfSize: file.sizeType)
            
            let averageHours = averageTime.0
            let averageMins = averageTime.1
            let averageSecs = averageTime.2
            
            let maxHours = maxTime.0
            let maxMins = maxTime.1
            let maxSecs = maxTime.2
            
            let minHours = minTime.0
            let minMins = minTime.1
            let minSecs = minTime.2
            
            if averageHours == 0 && averageMins == 0 && averageSecs == 0 {
                averageLabel.text = "Time is to short to calculate"
            } else if Double(averageHours) > 99999.0 {
                averageLabel.text = "Time is to long to calculate"
            } else {
                averageLabel.text = "Hours: \(averageHours), Minutes: \(averageMins), Seconds: \(averageSecs)"
            }
            
            if maxHours == 0 && maxMins == 0 && maxSecs == 0 {
                minLabel.text = "Time is to small to calculate"
            } else if Double(maxHours) > 99999.0 {
                minLabel.text = "Time is to long to calculate"
            } else {
                minLabel.text = "Hours: \(maxHours), Minutes: \(maxMins), Seconds: \(maxSecs)"
            }
            
            if minHours == 0 && minMins == 0 && minSecs == 0 {
                maxLabel.text = "Time is to small to calculate"
            } else if Double(minHours) > 99999.0 {
                maxLabel.text = "Time is to long to calculate"
            } else {
                maxLabel.text = "Hours: \(minHours), Minutes: \(minMins), Seconds: \(minSecs)"
            }
        }
    }
}



