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
    
    // FIXME: move to store
    var touched = Set<Int>()
    var delegateTarget: Touchable!
    var currentFrame: UIImage = UIImage()
    
    init(delegateTarget: Touchable) {
        super.init()
        mainStore.subscribe(self)
        self.delegateTarget = delegateTarget
        self.delegateTarget.touchDelegate = self
    }
    
    // MARK: Touch handlers
    // Pressed
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Get currently pressed keys
        let pressed = getSelectedKeys(touches)
        var released = Set<Int>()
        
        // This checks if you are moving
        if  touched != pressed {
            
            // Finds the released keys by seeing what's different
            released = touched.subtracting(pressed)
            
            // Resets the new touched
            touched = pressed
        }
        
        for key in touched {
            
            let cell = delegateTarget.mainView.cell(at: key) as! KeyboardCell
            
            // MARK: this whole thing gets the subset of the image relevant to the cell, then
            // gets the average color,
            // then gets the color in the palette it's closest to
            // then returns the most relevant note
            
            let globalPos = cell.globalPoint!

            let w = CGFloat(mainStore.state.keyBoardCellWidth)
            
            let imageViewScale = max(currentFrame.size.width / UIScreen.main.bounds.width,
                                     currentFrame.size.height / UIScreen.main.bounds.height)

            let cropZone = CGRect(x: (globalPos.x - (2*w)) * imageViewScale,
                                  y: globalPos.y * imageViewScale,
                                  width: w * imageViewScale,
                                  height: w * imageViewScale)

            let drawImage = currentFrame.cgImage!.cropping(to: cropZone)
            
            if let d = drawImage {
                
                let bimage = UIImage(cgImage: drawImage!)
                let avg = ColorThief.getColor(from: bimage)
                let cn = cell.calculateClosestColorBucket(color: avg!)
                
            }
            
            UIView.animate(withDuration: 0.15) {
                cell.blurEffectView.layer.opacity = 1
            }
        }
        
        for key in released {
            let cell = delegateTarget.mainView.cell(at: key) as! KeyboardCell
            UIView.animate(withDuration: 0.75) {
                cell.blurEffectView.layer.opacity = 0
                cell.backgroundColor = UIColor.clear
            }
        }
        
        // TODO:
        // Draw mode with chords
        
    }
    
    // Released
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let released = getSelectedKeys(touches)
        for key in released {
            let cell = delegateTarget.mainView.cell(at: key) as! KeyboardCell
            
            UIView.animate(withDuration: 0.75) {
                cell.blurEffectView.layer.opacity = 0
                cell.backgroundColor = UIColor.clear

            }
        }

    }
    
    func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        let released = getSelectedKeys(touches)
        for key in released {
            let cell = delegateTarget.mainView.cell(at: key) as! KeyboardCell
            
            UIView.animate(withDuration: 0.75) {
                cell.blurEffectView.layer.opacity = 0
                cell.backgroundColor = UIColor.clear

            }
        }
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

extension TouchHandler: StoreSubscriber {
    func newState(state: AppState) {
        currentFrame = state.lastFrame
        // grab the frame and the touch, then determine the
    }
}
