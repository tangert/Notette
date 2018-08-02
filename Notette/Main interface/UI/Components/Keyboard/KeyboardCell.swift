//
//  KeyboardCell.swift
//  Notette
//
//  Created by Tyler Angert on 8/1/18.
//  Copyright © 2018 Tyler Angert. All rights reserved.
//

import Foundation
import UIKit
import ColorThiefSwift // Eventually move this out to a color processer

class KeyboardCell: UIButton {
    
    // MARK: Visual setup
    var blurEffectView: UIVisualEffectView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
        
        self.addTarget(self, action: #selector(touchUpOutside), for: .touchUpOutside)
    }
    
    @objc func touchUpOutside() {
        print("touch up outside")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        guard let touch = touches.first, self.bounds.contains(touch.location(in: self))  else {
            return
        }
        
        print("touchesBegan") // Replace by your own code
        self.blurEffectView.layer.opacity = 1

        
//        if let touch = touches.first {
//            if touch.view == self {
//               print("Dragging in!")
//                print(touch.location(in: self).x)
//
//                self.blurEffectView.layer.opacity = 1
//
//
//            } else {
//
//                self.blurEffectView.layer.opacity = 0
//
//                return
//            }
//
//        }
    }
    
    func testTouches(touches: NSSet!) {
        // Get the first touch and its location in this view controller's view coordinate system
        let touch = touches.allObjects[0] as! UITouch
        let touchLocation = touch.locationInView(self.view)
        
        for obstacleView in obstacleViews {
            // Convert the location of the obstacle view to this view controller's view coordinate system
            let obstacleViewFrame = self.view.convertRect(obstacleView.frame, fromView: obstacleView.superview)
            
            // Check if the touch is inside the obstacle view
            if CGRectContainsPoint(obstacleViewFrame, touchLocation) {
                println("Game over!")
            }
        }
    }
    
//    var wasInButton = false
//
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let t = touches.first {
//            let point = t.location(in: self)
//            // moving in to the button
//            if frame.contains(point) && !wasInButton {
//                // trigger animation
//                UIView.animate(withDuration: 0.2) {
//                    self.blurEffectView.layer.opacity = 1
//                }
//                wasInButton = true
//            }
//            // moving out of the button
//            if !frame.contains(point) && wasInButton {
//                // trigger animation
//                UIView.animate(withDuration: 0.2) {
//                    self.blurEffectView.layer.opacity = 0
//                }
//                wasInButton = false
//            }
//        }
//    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.2) {
            self.blurEffectView.layer.opacity = 0
        }
    }
    
    init(data: ColorNote) {
        super.init(frame: .zero)
        populate(data: data)
    }
    
    func calculateClosestColorBucket() -> ColorNote {
        //1. Grab the image context below the current cell from the UIview image
        let imageContext = getImageContext()
        
        //2. Obtain the average color of that image from ColorThief
        let color = ColorThief.getColor(from: imageContext)
        
        //3. Loop through all of the current colors and obtain the closest color
        var currentMin = Int.max
        var minBucket: ColorNote!
        
        for cn in mainStore.state.colorNoteData {
            
            let colRgb = cn.color.rgb()
            
            let rDif = Int(color!.r) - colRgb!.r
            let gDif = Int(color!.g) - colRgb!.g
            let bDif = Int(color!.b) - colRgb!.b
            
            let totalDif = rDif + gDif + bDif
            
            if totalDif < currentMin {
                currentMin = totalDif
                minBucket = cn
            }
        }
        
        //4. Now you have your relevant note and color
        return minBucket
    }
    
    func getImageContext() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 0.0)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let imageContext = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageContext!
    }
    
    // MARK: Population
    func populate(data: ColorNote) {
        // Depending on the data, create a sound relevant to the color bucket it belongs in
        UIView.animate(withDuration: 0.25) {
            self.backgroundColor = data.color
        }
    }
    
    // MARK: User interactions
    // FIXME: create touch up inside interactions and delegate for manager?
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
