//
//  MainInterface_Reducer.swift
//  Notette
//
//  Created by Tyler Angert on 7/29/18.
//  Copyright © 2018 Tyler Angert. All rights reserved.
//

import Foundation
import ReSwift

func MainInteface_Reducer(action: Action, state: AppState?) -> AppState {

    var state = state ?? AppState()
    
    switch action {
    case let a as setNewColorPalette:
        state.colors = a.colors
        
    case let a as userTouchedKeyboard:
        state.userIsTouchingKeyboard = a.touched
        
    case let a as setTouchedKeyboardCells:
        state.touchedKeyboardCells = a.cells
        
    case let a as setReleasedKeyboardCells:
        state.releasedKeyboardCells = a.cells
        
    case let a as setLastFrame:
        state.lastFrame = a.frame
        
    default:
        return state
    }
    
    return state
}
