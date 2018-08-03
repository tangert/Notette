//
//  KeySelector.swift
//  Notette
//
//  Created by Tyler Angert on 7/30/18.
//  Copyright © 2018 Tyler Angert. All rights reserved.
//

import Foundation
import PinLayout

class KeySelector: UIView {
    
    // MARK: Subviews
    var scaleTypeSelector = UIButton()
    var keySelector = UIButton()
    
    // MARK: Adding subviews
    init() {
        super.init(frame: .zero)
        
        // Scale Type
        scaleTypeSelector.backgroundColor = UIColor.clear
        scaleTypeSelector.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
        addSubview(scaleTypeSelector)
        
        // Key
        keySelector.backgroundColor = UIColor.clear
        keySelector.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
        addSubview(keySelector)
    }
    
    // MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Top left of container
        scaleTypeSelector.pin.top(pin.safeArea).left(pin.safeArea)
        
        // To the right of the previous button
        keySelector.pin.right(of: scaleTypeSelector).marginLeft(10)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
