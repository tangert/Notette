//
//  TopControls.swift
//  Notette
//
//  Created by Tyler Angert on 7/30/18.
//  Copyright © 2018 Tyler Angert. All rights reserved.
//

import Foundation
import UIKit
import FlexLayout
import PinLayout
import CollectionKit

class TopControls: UIView {
    
    fileprivate let rootFlexContainer = UIView()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = UIColor.clear
        
        // Declaritively lay out subviews
        let keySelector = KeySelector()
        
        // Create the palette
        let palette = Palette()
        
        rootFlexContainer.flex.direction(.row).justifyContent(.spaceBetween).define { (flex) in
            
            flex.addItem(keySelector)
            flex.addItem(palette)
        
        }
        
        addSubview(rootFlexContainer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Layout the flexbox container using PinLayout
        // NOTE: Could be also layouted by setting directly rootFlexContainer.frame
        rootFlexContainer.pin.top().horizontally().margin(pin.safeArea)
        
        // Then let the flexbox container layout itself
        rootFlexContainer.flex.layout(mode: .adjustHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
