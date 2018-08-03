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
struct userTouchedKeyboard: Action {
    var type = "USER_TOUCHED_KEYBOARD"
    var touched: Bool
    init(touched: Bool) {
        self.touched = touched
    }
}

// Sets the currently selected keyboard cells as indices
struct setTouchedKeyboardCells: Action {
    var type = "SET_TOUCHED_KEYBOARD_CELLS"
    var cells: [Int]
    init(cells: [Int]) {
        self.cells = cells
    }
}

struct setReleasedKeyboardCells: Action {
    var type = "SET_RELEASED_KEYBOARD_CELLS"
    var cells: [Int]
    init(cells: [Int]) {
        self.cells = cells
    }
}

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

struct setLastFrame: Action {
    var type = "SET_LAST_FRAME"
    var frame: UIImage
    init(frame: UIImage) {
        self.frame = frame
    }
}
