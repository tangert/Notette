//
//  KeyboardCell.swift
//  Notette
//
//  Created by Tyler Angert on 8/1/18.
//  Copyright © 2018 Tyler Angert. All rights reserved.
//

import Foundation
import UIKit
import ReSwift
import ColorThiefSwift
import MusicTheorySwift

/* TODO :
     Visuals:
     1. Glowing when holding down
     2. Drop shadow
 
     Interaction:
     1. 3D touch: to turn on keyboard
 */

enum KeyState {
    case pressed
    case notPressed
}

class KeyboardCell_View: UIButton {
    
    var keyState: KeyState = .notPressed
    var blurEffectView: UIVisualEffectView!
    var previousNote: Note!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        
        let CORNER_RADIUS: CGFloat = 5
        
        // Corner radius
        clipsToBounds = true
        layer.cornerRadius = CORNER_RADIUS
        
        // Background blur
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.layer.opacity = 0
        blurEffectView.clipsToBounds = true
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Insert the blur and shadow all the way behind
        insertSubview(blurEffectView, at: 0)
        
        // Avoid conflict with parent view
        isUserInteractionEnabled = false
        
    }
    
    // Adjust views here
    // Called from parent view
    // FIXME: SET THE STATE ONLY WHEN IT IS CHANGED
    
    func setState(state: KeyState) {
        
        keyState = state
        
        if (keyState == .pressed) {
            
            DispatchQueue.main.async {
                
                // Set the view state
                UIView.animate(withDuration: 0.15) {
                    self.blurEffectView.layer.opacity = 1
                }
                
                // Find the note
                let closestColorNote = self.calculateClosestColorBucket()
                let currentNote = closestColorNote.note
                
                DispatchQueue.main.async {
                    Keyboard.synth.playNote(currentNote)
                }
                
                self.previousNote = currentNote
                
            }
            
        } else {
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.75) {
                    self.blurEffectView.layer.opacity = 0
                    self.backgroundColor = UIColor.clear
                }
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    guard let p = self.previousNote else { return }
                    Keyboard.synth.stopNote(p)
                }
            }
        }
        
        DispatchQueue.main.async {
            self.setNeedsDisplay()
        }
        
    }
    
    // MARK: Fill the cell with data
    init(data: ColorNote) {
        super.init(frame: .zero)
        populate(data: data)
    }
    
    func populate(data: ColorNote) {
        // Depending on the data, create a sound relevant to the color bucket it belongs in
        UIView.animate(withDuration: 0.25) {
            self.backgroundColor = data.color
        }
        
        self.setTitle(data.note.type.description, for: .normal)
    }
    
    
    /////////////////////////////////////////////////////////////////////
    // FIXME: Closest color bucket
    /////////////////////////////////////////////////////////////////////
    
    // MARK: Calculates the most relevant note for each cell based on the average color underneath it
    // This should be in a color comparison object as a static function
    // or be dumb and take in a reference color, then a color palette as input
    
    func calculateClosestColorBucket() -> ColorNote {
        
        var currentMin = Double.greatestFiniteMagnitude
        var minBucket: ColorNote!
        
        let globalPos = self.globalPoint!
        let w = CGFloat(mainStore.state.keyBoardCellWidth)
        let currentFrame = mainStore.state.lastFrame
        
        let imageViewScale = max(currentFrame.size.width / UIScreen.main.bounds.width,
                                 currentFrame.size.height / UIScreen.main.bounds.height)
        
        let cropZone = CGRect(x: (globalPos.x - (2*w)) * imageViewScale,
                              y: globalPos.y * imageViewScale,
                              width: w * imageViewScale,
                              height: w * imageViewScale)
        
        let drawImage = currentFrame.cgImage!.cropping(to: cropZone)
        
        // FIXME: Clean up
        
        guard let d = drawImage else {
            return ColorNote(color: UIColor.clear, note: Note(type: .c, octave: 4) )
        }
        
        let bimage = UIImage(cgImage: drawImage!)
        guard let avgColor = ColorThief.getColor(from: bimage) else {
            return ColorNote(color: UIColor.clear, note: Note(type: .c, octave: 4))
        }
        
        // For each color note pair
        for cn in mainStore.state.colorNoteData {
            
            // Grab the rgb values from the current palette
            let inputColor = (Int(avgColor.r), Int(avgColor.g), Int(avgColor.b), 1)
            let paletteColor = cn.color.rgb()!
            
            let d = colorDistance(color1: inputColor, color2: paletteColor)
            
            if d < currentMin {
                currentMin = d
                minBucket = cn
            }
        }
        
        //4. Now you have your relevant note and color
        return minBucket
    }
    
    // FIXME: Delta E estimator
    func colorDistance(color1: (r: Int,g: Int,b: Int, a: Int),
                       color2: (r: Int,g: Int,b: Int, a: Int)) -> Double {
        let rmean = ( color1.r + color2.r ) / 2
        let r = color1.r - color2.r
        let g = color1.g - color2.g
        let b = color1.b - color2.b
        
        let f = ((512+rmean)*r*r) >> 8
        let s = 4*g*g
        let t = ( (767-rmean) * (b*b) ) >> 8
        
        return sqrt(Double(f + s + t))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
