//
//  Settings.swift
//  Download-It
//
//  Created by Justin Carver on 9/29/16.
//  Copyright © 2016 Justin Carver. All rights reserved.
//

import Foundation

class Settings: Equatable {
    
    private let kWifiMin = "WifiMin"
    private let kWifiMax = "WifiMax"
    private let kEtherMin = "EtherMin"
    private let kEtherMax = "EtherMax"
    
    var minWifi: Double
    var maxWifi: Double
    var minEther: Double
    var maxEther: Double
    
    var dictionaryRep: [String: Double] {
        return [kWifiMin: minWifi, kWifiMax: maxWifi, kEtherMin: minEther, kEtherMax: maxEther]
    }
    
    init(maxWifi: Double, minWifi: Double, minEther: Double, maxEther: Double) {
        self.minWifi = minWifi
        self.maxWifi = maxWifi
        self.minEther = minEther
        self.maxEther = maxEther
    }
    
    init?(dictionary: [String: Double]) {
        guard let minWifi = dictionary[kWifiMin], let maxWifi = dictionary[kWifiMax], minEther = dictionary[kEtherMin], maxEther = dictionary[kEtherMax] else { return nil }
        self.minWifi = minWifi
        self.maxWifi = maxWifi
        self.maxEther = maxEther
        self.minEther = minEther
    }
}

func ==(lhs: Settings, rhs: Settings) -> Bool {
    return lhs.minWifi == rhs.minWifi && lhs.maxWifi == rhs.maxWifi && lhs.minEther == rhs.minEther && lhs.maxEther == rhs.maxEther
}
