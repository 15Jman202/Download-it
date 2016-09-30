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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        if let text = textField.text where text != "" {
            file.size = Double(text)!
        }

        guard let settings = SpeedSettings.sharedContoller.settings else { print("Must have speed settings setup"); return false }
        
        if file.isPluggedIn == false {
            let averageSpeed = CalculatorController.sharedController.findAverageSpeed(settings.minWifi, max: settings.maxWifi)
            let averageTime = CalculatorController.sharedController.findTimeFrom(averageSpeed, sizeOfFile: file.size, typeOfSize: file.sizeType)
            let maxTime = CalculatorController.sharedController.findTimeFrom(settings.maxWifi, sizeOfFile: file.size, typeOfSize: file.sizeType)
            let minTime = CalculatorController.sharedController.findTimeFrom(settings.minWifi, sizeOfFile: file.size, typeOfSize: file.sizeType)
            
            let averagehours = averageTime.0
            let averagemins = averageTime.1
            let averagesecs = averageTime.2
            
            averageLabel.text = "Hours: \(averagehours), Minutes: \(averagemins), Seconds: \(averagesecs)"
            
            let maxhours = maxTime.0
            let maxmins = maxTime.1
            let maxsecs = maxTime.2
            
            maxLabel.text = "Hours: \(maxhours), Minutes: \(maxmins), Seconds: \(maxsecs)"
            
            let minhours = minTime.0
            let minmins = minTime.1
            let minsecs = minTime.2
            
            minLabel.text = "Hours: \(minhours), Minutes: \(minmins), Seconds: \(minsecs)"
            
        } else {
            
            let averageSpeed = CalculatorController.sharedController.findAverageSpeed(settings.minEther, max: settings.maxEther)
            let averageTime = CalculatorController.sharedController.findTimeFrom(averageSpeed, sizeOfFile: file.size, typeOfSize: file.sizeType)
            let maxTime = CalculatorController.sharedController.findTimeFrom(settings.maxEther, sizeOfFile: file.size, typeOfSize: file.sizeType)
            let minTime = CalculatorController.sharedController.findTimeFrom(settings.minEther, sizeOfFile: file.size, typeOfSize: file.sizeType)
            
            let averagehours = averageTime.0
            let averagemins = averageTime.1
            let averagesecs = averageTime.2
            
            averageLabel.text = "Hours: \(averagehours), Minutes: \(averagemins), Seconds: \(averagesecs)"
            
            let maxhours = maxTime.0
            let maxmins = maxTime.1
            let maxsecs = maxTime.2
            
            maxLabel.text = "Hours: \(maxhours), Minutes: \(maxmins), Seconds: \(maxsecs)"
            
            let minhours = minTime.0
            let minmins = minTime.1
            let minsecs = minTime.2
            
            minLabel.text = "Hours: \(minhours), Minutes: \(minmins), Seconds: \(minsecs)"
        }
        
        return true
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
        } else {
            file.isPluggedIn = true
        }
    }
    @IBAction func valueChanged(sender: UIStepper) {
        switch sender.value {
        case 0:
            file.sizeType = Size.KB
            sizeLabel.text = "KB"
        case 1:
            file.sizeType = Size.MB
            sizeLabel.text = "\(Size.MB)"
        case 2:
            file.sizeType = Size.GB
            sizeLabel.text = "\(Size.GB)"
        case 3:
            file.sizeType = Size.TB
            sizeLabel.text = "\(Size.TB)"
        default:
            print("Error: NO TYPE")
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
        if let text = sizeOfFileTextField.text, let double = Double(text) {
            file.size = double
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        averageLabel.text = ""
        maxLabel.text = ""
        minLabel.text = ""
        sizeOfFileTextField.delegate = self
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
