//
//  MainInterface_Actions.swift
//  Notette
//
//  Created by Tyler Angert on 7/29/18.
//  Copyright © 2018 Tyler Angert. All rights reserved.
//

import Foundation
import ReSwift

 // MARK: User actions

/*
 1. Select key
 2. select scale
 3. Turn keyboard on / off
 4. Touch key
 5. filter palette
 */

// MARK: Internal actions
struct setNewColorPalette: Action {
    
    var type = "SET_NEW_COLOR_PALETTE"
    
    var colors: [UIColor]
    
    init(colors: [UIColor]) {
        self.colors = colors
    }
}
