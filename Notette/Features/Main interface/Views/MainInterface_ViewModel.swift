//
//  MainInterface_ViewModel.swift
//  Notette
//
//  Created by Tyler Angert on 7/29/18.
//  Copyright © 2018 Tyler Angert. All rights reserved.
//

import Foundation
import UIKit
import FlexLayout
import PinLayout

class MainInterface_ViewModel: UIView {
    
    fileprivate let rootFlexContainer = UIView()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        
        // Declaritively lay out subviews
        let topControls = TopControls()
        
        // TODO: implement other view components
        // let cameraView = CameraView()
        // let keyboard = Keyboard()
        
        rootFlexContainer.flex.direction(.column).justifyContent(.spaceAround).padding(20).define { (flex) in
            
            flex.addItem(topControls)
            
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
