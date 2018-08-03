//
//  TouchHandler.swift
//  Notette
//
//  Created by Tyler Angert on 8/2/18.
//  Copyright © 2018 Tyler Angert. All rights reserved.
//

import Foundation
import UIKit
import ReSwift
import CollectionKit
import ColorThiefSwift

// MARK: special delegate to send over touch methods and send to store
protocol TouchDelegate: AnyObject {
    // Pressed
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    
    // Released
    func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    
}

// MARK: Touchable protocol to generically handle broad touch events
protocol Touchable: AnyObject {
    var touchDelegate: TouchDelegate? { get set }
    var mainView: CollectionView! { get set }
}


// FIXME:
// All the styling and shit should be done via state changes INSIDE of each of the button objects.
// All the touch handler should care about is deciding what is touched/visible by indices.

class TouchHandler: NSObject, TouchDelegate {
    
    var previousTouched = Set<Int>()
    var released = Set<Int>()
    
    var delegateTarget: Touchable!
    var currentFrame: UIImage = UIImage()
    
    init(delegateTarget: Touchable) {
        super.init()
        self.delegateTarget = delegateTarget
        self.delegateTarget.touchDelegate = self
    }
    
    // MARK: Touch handlers
    // Pressed down
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        mainStore.dispatch(userTouchedKeyboard(touched: true))
    }
    
    // Pressing across
    // FIXME: Handle multiple touches
    // FIXME: Some weird behavior with "remembering" touches
    // TODO: Draw mode with chords
    
    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Set the last frame once it notices a touch
        mainStore.dispatch(setLastFrame(frame: FrameCaptureHandler.capturedImage))
        
        // Get currently pressed keys
        let touched = getSelectedKeys(touches)
        
        // This checks if you are moving
        if  touched != previousTouched {
            
            // Finds the released keys by seeing what's different
            released = touched.subtracting(previousTouched)
            
            // Resets the new touched
            previousTouched = touched
        }
        
        // Send touches to store
        mainStore.dispatch(setTouchedKeyboardCells(cells: Array(touched) ))
        mainStore.dispatch(setReleasedKeyboardCells(cells: Array(released) ))
        
    }
    
    // Released
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        mainStore.dispatch(userTouchedKeyboard(touched: false))
        mainStore.dispatch(setReleasedKeyboardCells(cells: Array(getSelectedKeys(touches)) ))
    }
    
    func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        mainStore.dispatch(userTouchedKeyboard(touched: false))
        mainStore.dispatch(setReleasedKeyboardCells(cells: Array(getSelectedKeys(touches)) ))
    }
    
    // Retrieves indices of the keys pressed inside of the collection view
    func getSelectedKeys(_ touches: Set<UITouch>) -> Set<Int> {
        var selected = Set<Int>()
        for touch in touches {
            let location = touch.location(in: self.delegateTarget as? UIView)
            if let cell = self.delegateTarget.mainView.indexForCell(at: location) {
                selected.insert(cell)
            }
        }
        return selected
    }
}
