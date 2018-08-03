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
    var key: NoteType = NoteType.c
    var scaleType: ScaleType = ScaleType.major
    var octave: Int = 5
    
    // Calculate the scale
    // Default to C Major, read only
    var currentScale: Scale {
        get {
            return Scale(type: scaleType, key: key)
        }
    }
    
    // The scale doesn't include 8 notes, just the first 7
    // Have to add on the ending note in the octave
    var notes: [Note] {
        get {
            var first7Notes = currentScale.notes(octave: octave)
            let endingOctave = Note(type: key, octave: octave+1)
            first7Notes.append(endingOctave)
            return first7Notes
        }
    }
    
    // Current frame palette data
    var colors: [UIColor] = [UIColor].init(repeating: UIColor.clear, count: 8)
    
    // Combined color / note data
    var colorNoteData: [ColorNote]  {
        get {
            return zip(colors, notes).map { ColorNote(color: $0, note: $1) }
        }
    }
    
    // Image data
    // FIXME: Only grab this when necessary to avoid unnecessary state changes constantly
    var lastFrame: UIImage = UIImage()
    
    // UI relevant controls
    var keyboardIsOn: Bool = false
    var keyBoardCellWidth: Int = 35
    var userIsTouchingKeyboard: Bool = false
    var touchedKeyboardCells = [Int]()
    var previousTouchedKeyboardCells = [Int]()
    var releasedKeyboardCells = [Int]()
}

func appReducer(action: Action, state: AppState?) -> AppState {
    return AppState()
}

// Finally, define the store
var mainStore = Store<AppState>(reducer: MainInteface_Reducer, state: nil)
