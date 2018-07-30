//
//  AppState.swift
//  Notette
//
//  Created by Tyler Angert on 7/28/18.
//  Copyright © 2018 Tyler Angert. All rights reserved.
//

import Foundation
import ReSwift
import MusicTheorySwift

struct AppState: StateType {
    
    // Select these two independently from the UI
    var scaleType: ScaleType = ScaleType.major
    var key: NoteType = NoteType.c
    
    // Calculate the scale
    // Default to C Major, read only
    var currentScale: Scale {
        get {
            return Scale(type: self.scaleType, key: self.key)
        }
    }
    
    var octave: Int = 4
    
    // Array of colors
    // Initialize with all white
    var palette: [UIColor] = [UIColor].init(repeating: UIColor.white, count: 8)
    
    // UI relevant controls
    var keyboardIsOn: Bool = false
    var cameraIsOn: Bool = false
    var userIsInteractingWithKeyboard: Bool = false
    
    // TODO: selected notes / filtering
}
