//
//  File.swift
//  Download-It
//
//  Created by Justin Carver on 9/29/16.
//  Copyright © 2016 Justin Carver. All rights reserved.
//

import Foundation

class File {
    
    var size: Double
    var sizeType: Size
    var isPluggedIn: Bool
    
    init(size: Double = 0.0, sizeType: Size = Size.MB, isPluggedIn: Bool = false) {
        self.size = size
        self.sizeType = sizeType
        self.isPluggedIn = isPluggedIn
    }
}
