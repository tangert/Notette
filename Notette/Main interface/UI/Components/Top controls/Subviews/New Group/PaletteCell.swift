//
//  PaletteCell.swift
//  Notette
//
//  Created by Tyler Angert on 8/1/18.
//  Copyright © 2018 Tyler Angert. All rights reserved.
//

import Foundation
import UIKit

class PaletteCell: UIButton {
    
    // MARK: Visual setup
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let CORNER_RADIUS: CGFloat = 5
        
        // Label
        titleLabel?.textAlignment = .center
        titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .black)
        titleLabel?.textColor = UIColor.white.withAlphaComponent(0.5) // unclicked opacity
        
        // Corner radius
        clipsToBounds = true
        layer.cornerRadius = CORNER_RADIUS
        
//        Shadow isn't working...
//        let shadowLayer = CAShapeLayer()
//        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 5).cgPath
//        shadowLayer.fillColor = UIColor.black.cgColor
//
//        shadowLayer.shadowColor = UIColor.darkGray.cgColor
//        shadowLayer.shadowPath = shadowLayer.path
//        shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
//        shadowLayer.shadowOpacity = 0.5
//        shadowLayer.shadowRadius = 5
//        layer.insertSublayer(shadowLayer, at: 0)

        // Background blur
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.clipsToBounds = true
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Insert the blur and shadow all the way behind
        insertSubview(blurEffectView, at: 0)


    }
    
    init(data: ColorNote) {
        super.init(frame: .zero)
        populate(data: data)
    }
    
    // MARK: Population
    func populate(data: ColorNote) {
        
        // Animate the background fade in
        UIView.animate(withDuration: 0.25) {
            self.backgroundColor = data.color.withAlphaComponent(0.75)
        }
        
        // Set the correct note
        setTitle(data.note.type.description, for: .normal)
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
