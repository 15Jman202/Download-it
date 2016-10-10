//
//  CalculatorController.swift
//  Download-It
//
//  Created by Justin Carver on 9/28/16.
//  Copyright © 2016 Justin Carver. All rights reserved.
//

import Foundation

enum Size: String {
    case KB = "KB"
    case MB = "MB"
    case GB = "GB"
    case TB = "TB"
}

class CalculatorController {
    
    static let sharedController = CalculatorController()
    
    func findAverageSpeed(min: Double, max: Double) -> Double {
        return (min + max) / 2
    }
    
    func secondsToHoursMinutesSeconds (seconds : Double) -> (Int, Int, Int) {
        let (hr,  minf) = modf (seconds / 3600)
        let (min, secf) = modf (60 * minf)
        return (Int(hr), Int(min), Int(60 * secf))
    }
    
    func findTimeFrom(downloadSpeed: Double, sizeOfFile: Double, typeOfSize: Size) -> (Int, Int, Int) {
        
        var size = sizeOfFile
        
        if typeOfSize == Size.KB {
            size /= 1000
        } else if typeOfSize == Size.GB {
            size *= 1000
        } else if typeOfSize == Size.TB {
            size *= 1000000
        }
        
        let seconds = (size / downloadSpeed)
        guard seconds >= 0.000000001 else { return (0, 0, 0) }
        guard seconds <= 999999999999999999999999.9 else { return (99999999999999, 0, 0)}
        return secondsToHoursMinutesSeconds(seconds)
    }
}
