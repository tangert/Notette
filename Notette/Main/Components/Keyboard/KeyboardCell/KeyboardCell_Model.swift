//
//  KeyboardCellModel.swift
//  Notette
//
//  Created by Tyler Angert on 8/3/18.
//  Copyright © 2018 Tyler Angert. All rights reserved.
//

import Foundation
import UIKit

struct KeyboardCell_Model {
    
    // Which cell it is
    var index: Int
    
    // Closest color bucket it belonds to
    var closestColor: ColorNote
    
    // Frame of the cell relative to the whole view
    var globalFrame: CGRect
    
    // Location of the cell relative relative to the whole view
    var globalPoint: CGPoint {
        get {
            return globalFrame.origin
        }
    }
}
