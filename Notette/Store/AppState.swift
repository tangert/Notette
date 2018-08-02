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
    var octave: Int = 4
    
    // Calculate the scale
    // Default to C Major, read only
    var currentScale: Scale {
        get {
            return Scale(type: scaleType, key: key)
        }
    }
    
    var notes: [Note] {
        get {
            
            var original = currentScale.notes(octave: octave)
            
            // The scale doesn't include 8 notes, just the first 7
            // Have to add on the ending note in the octave
            let endingOctave = Note(type: key, octave: octave+1)
            original.append(endingOctave)
            
            return original
        }
    }
    
    // Array of colors
    // Initialize with all white
    var colors: [UIColor] = [UIColor].init(repeating: UIColor.clear, count: 8)
    
    var colorNoteData: [ColorNote]  {
        get {
            return zip(colors, notes).map { ColorNote(color: $0, note: $1) }
        }
    }
    
    // Image data
    var lastFrame: UIImage = UIImage()
    var keyBoardCellWidth: Int = 35
    
    // UI relevant controls
    var keyboardIsOn: Bool = false
    var cameraIsOn: Bool = false
    var userIsInteractingWithKeyboard: Bool = false
    
    // TODO: selected notes / filtering
    // Just store the indices
    var selectedKeyboardCells = [Int]()
}

func appReducer(action: Action, state: AppState?) -> AppState {
    return AppState()
}

// Finally, define the store
var mainStore = Store<AppState>(reducer: MainInteface_Reducer, state: nil)
