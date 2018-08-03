//
//  PaletteCell.swift
//  Notette
//
//  Created by Tyler Angert on 8/1/18.
//  Copyright © 2018 Tyler Angert. All rights reserved.
//

import Foundation
import UIKit

// FIXME: Refactor into view, model, viewmodel

class PaletteCell_View: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Initial layout setup
        setupLayout()
        
    }
    
    init(data: ColorNote) {
        super.init(frame: .zero)
        populate(data: data)
    }
    
    // MARK: Visual and layout
    func setupLayout() {
        
        let CORNER_RADIUS: CGFloat = 5
        
        // Label
        titleLabel?.textAlignment = .center
        titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .black)
        titleLabel?.textColor = UIColor.white.withAlphaComponent(0.5) // unclicked opacity
        
        // Corner radius
        clipsToBounds = true
        layer.cornerRadius = CORNER_RADIUS
        
        // Background blur
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.clipsToBounds = true
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Insert the blur and shadow all the way behind
        insertSubview(blurEffectView, at: 0)

        
    }
    
    // MARK: Population
    func populate(data: ColorNote) {
        
        UIView.animate(withDuration: 0.2) {
            self.backgroundColor = data.color
        }
        
        // Set the correct note
        setTitle(data.note.type.description, for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
