//
//  MainScreen.swift
//  Download-It
//
//  Created by Justin Carver on 9/28/16.
//  Copyright © 2016 Justin Carver. All rights reserved.
//

import UIKit

class MainScreen: UIViewController, UITextFieldDelegate {
    
    var file = File()
    
    @IBAction func sizeOfTextFieldDidChange() {
        
        guard let text = sizeOfFileTextField.text where text != "" else { return }
        
        file.size = Double(text)!
        
        updateTextFields()
    }

    @IBAction func screenTapped(sender: UITapGestureRecognizer) {
        
        sizeOfFileTextField.resignFirstResponder()
        
        guard let text = sizeOfFileTextField.text where text != "" else { return }
        
        file.size = Double(text)!
        
        updateTextFields()
    }
    
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var seperationLine: UILabel!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var sizeLabel: UILabel!
    
    @IBOutlet weak var sizeOfFileTextField: UITextField!
    
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        SpeedSettings.sharedContoller.loadFromPersistStore()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        averageLabel.text = ""
        maxLabel.text = ""
        minLabel.text = ""
        sizeOfFileTextField.delegate = self
    }
    
    func displaySettingsAlert() {
        let alertController = UIAlertController(title: "Please setup your speed settings", message: nil, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
        
        presentViewController(alertController, animated: true, completion: nil)
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
            
            if Double(averageHours) > 9999.0 || Double(maxHours) > 999.0 || Double(minHours) > 999.0 {
                averageLabel.text = "Time is to long to calculate"
                maxLabel.text = averageLabel.text
                minLabel.text = averageLabel.text
                return
            }
            
            if averageHours == 0 && averageMins == 0 && averageSecs == 0 {
                averageLabel.text = "Time is to short to calculate"
            } else {
                averageLabel.text = "Hours: \(averageHours), Minutes: \(averageMins), Seconds: \(averageSecs)"
            }
            
            if maxHours == 0 && maxMins == 0 && maxSecs == 0 {
                minLabel.text = "Time is to small to calculate"
            } else {
                minLabel.text = "Hours: \(maxHours), Minutes: \(maxMins), Seconds: \(maxSecs)"
            }
            
            if minHours == 0 && minMins == 0 && minSecs == 0 {
                maxLabel.text = "Time is to small to calculate"
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
            
            guard Double(averageHours) == Double.infinity && Double(averageMins) == Double.infinity && Double(averageSecs) == Double.infinity || Double(maxHours) == Double.infinity && Double(maxMins) == Double.infinity && Double(maxSecs) == Double.infinity || Double(minHours) == Double.infinity && Double(minMins) == Double.infinity && Double(minSecs) == Double.infinity else {
                averageLabel.text = "Time is to long to calculate"
                maxLabel.text = averageLabel.text
                minLabel.text = averageLabel.text
                return
            }
            
            if averageHours == 0 && averageMins == 0 && averageSecs == 0 {
                averageLabel.text = "Time is to short to calculate"
            } else {
                averageLabel.text = "Hours: \(averageHours), Minutes: \(averageMins), Seconds: \(averageSecs)"
            }
            
            if maxHours == 0 && maxMins == 0 && maxSecs == 0 {
                minLabel.text = "Time is to small to calculate"
            } else {
                minLabel.text = "Hours: \(maxHours), Minutes: \(maxMins), Seconds: \(maxSecs)"
            }
            
            if minHours == 0 && minMins == 0 && minSecs == 0 {
                maxLabel.text = "Time is to small to calculate"
            } else {
                maxLabel.text = "Hours: \(minHours), Minutes: \(minMins), Seconds: \(minSecs)"
            }
        }
    }
}

//var averageLabel = UILabel()
//var maxLabel = UILabel()
//var minLabel = UILabel()
//
//var stackView = UIStackView()
//
//var averageView = UIStackView()
//var maxView = UIStackView()
//var minView = UIStackView()
//
//func setupStackView() {
//
//    stackView = UIStackView(arrangedSubviews: [averageView, maxView, minView])
//
//    stackView.axis = .Vertical
//    stackView.distribution = .FillEqually
//    stackView.alignment = .Fill
//    stackView.spacing = 0
//    stackView.translatesAutoresizingMaskIntoConstraints = false
//
//    view.addSubview(stackView)
//}
//
//func setupLabels() {
//
//    averageLabel.text = "Your average download time is..."
//    averageLabel.font = UIFont(name: "Krungthep", size: 20.0)
//
//    maxLabel.text = "Your maximum download time is..."
//    maxLabel.font = UIFont(name: "Krungthep", size: 20.0)
//
//    minLabel.text = "Your minimum download time is..."
//    minLabel.font = UIFont(name: "Krungthep", size: 20.0)
//
//    averageView.addSubview(averageLabel)
//    maxView.addSubview(maxLabel)
//    minView.addSubview(minLabel)
//}
//
//func setupConstraints() {
//
//    let verticalStackViewTop = NSLayoutConstraint(item: stackView, attribute: .Top, relatedBy: .Equal, toItem: self.seperationLine, attribute: .Bottom, multiplier: 1.0, constant: 0)
//    let verticalStackViewTrailing = NSLayoutConstraint(item: stackView, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1.0, constant: 0)
//    let verticalStackViewLeading = NSLayoutConstraint(item: stackView, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1.0, constant: 0)
//    let verticalStackViewBottom = NSLayoutConstraint(item: stackView, attribute: .Bottom, relatedBy: .Equal, toItem: self.toolBar, attribute: .Top, multiplier: 1.0, constant: 0)
//
//    view.addConstraints([verticalStackViewTop, verticalStackViewBottom, verticalStackViewLeading, verticalStackViewTrailing])
//}



