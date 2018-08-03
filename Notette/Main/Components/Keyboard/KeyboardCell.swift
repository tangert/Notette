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
import ColorThiefSwift // Eventually move this out to a color processer

// Key receives information from store
class KeyboardCell: UIButton {
    
    // MARK: Key state
    enum KeyState {
        case pressed
        case notPressed
    }
    
    // Vary this state based on the selected keys from the store
    // When there's a new state, check against the index
    
    var keyState: KeyState = .notPressed
    
    // MARK: Visual setup
    // Turn the blur effect on / off based on state
    var blurEffectView: UIVisualEffectView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let CORNER_RADIUS: CGFloat = 5
        
        // Corner radius
        clipsToBounds = true
        layer.cornerRadius = CORNER_RADIUS
        
        // Background blur
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.regular)
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
    }
    
    // MARK: Pressing interactions from parent view
    func pressed() -> Bool {
        if keyState != .pressed {
            keyState = .pressed
            DispatchQueue.main.async {
                self.setNeedsDisplay()
            }
            return true
        } else {
            return false
        }
    }
    
    func released() -> Bool {
        if keyState != .notPressed {
            keyState = .notPressed
            DispatchQueue.main.async {
                self.setNeedsDisplay()
            }
            return true
        } else {
            return false
        }
    }
    
    // MARK: Calculates the most relevant note for each cell based on the average color underneath it
    // This should be in a color comparison object as a static function
    // or be dumb and take in a reference color, then a color palette as input
    
    func calculateClosestColorBucket(color: MMCQ.Color) -> ColorNote {
        
        var currentMin = Double.greatestFiniteMagnitude
        var minBucket: ColorNote!
        
        // For each color note pair
        for cn in mainStore.state.colorNoteData {
            
            // Grab the rgb values from the current palette
            let inputColor = (Int(color.r), Int(color.g), Int(color.b), 1)
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
    
    // rewrite this
    func colorDistance(color1: (r: Int,g: Int,b: Int, a: Int), color2: (r: Int,g: Int,b: Int, a: Int)) -> Double {
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
