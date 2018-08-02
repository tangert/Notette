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
    func calculateClosestColorBucket() -> ColorNote {
        
        
        //1. Grab the image context below the current cell from the UIview image
        let imageContext = getImageContext()
        
        
        // Try using sub image
        
        // the x and y are based on the current position of the button in the super view
//        let fromRect=CGRect(x:0,y:0,width:mainStore.state.keyBoardCellWidth,height:mainStore.state.keyBoardCellWidth)
//        let drawImage = image.cgImage!.cropping(to: fromRect)
//        let bimage = UIImage(cgImage: drawImage!)
        
        //2. Obtain the average color of that image from ColorThief
        let colors = ColorThief.getPalette(from: imageContext, colorCount: 3)
        let color = colors![0]
        print(color)
        
        //3. Loop through all of the current colors and obtain the closest color
        
        var currentMin = Float.greatestFiniteMagnitude
        var minBucket: ColorNote!
        
        // For each color note pair
        for cn in mainStore.state.colorNoteData {
            
            // Grab the rgb values from the current palette
            let colRgb = cn.color.rgb()
            print("palette rgb: \(colRgb)")
            print("cell rgb: \(color)")
            print("\n")
            // Calculate the r,g,b differences between the selected palette color
            // And the average color below the current cell
            
            let rDif = Int(color.r) - colRgb!.r
            let gDif = Int(color.g) - colRgb!.g
            let bDif = Int(color.b) - colRgb!.b
            
            let pctDiffRed   = Float(rDif)   / 255
            let pctDiffGreen = Float(gDif) / 255
            let pctDiffBlue   = Float(bDif)  / 255
            
            let pctDif = (pctDiffRed + pctDiffGreen + pctDiffBlue) / 3 * 100
            
            print("Difference: \(pctDif)")
            
            if pctDif < currentMin {
                currentMin = pctDif
                minBucket = cn
            }
        }
        
        //4. Now you have your relevant note and color
        return minBucket
    }
    
    // Helper method to retrieve the image below a UIView
    func getImageContext() -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let imageContext = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageContext!
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
