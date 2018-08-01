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
    let cameraView = CameraView(frame: UIScreen.main.bounds)
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        
        // Declaritively lay out subviews
        let topControls = TopControls()
        
        // FIXME: Create full keyboard
        let keyboard = Keyboard()
        
        rootFlexContainer.flex.direction(.column).justifyContent(.spaceAround).padding(20).define { (flex) in
            
            flex.addItem(topControls)
        }
        
        // Add camera view first
        addSubview(cameraView)
        
        // Add overlaying UI
        addSubview(rootFlexContainer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Layout the flexbox container using PinLayout
        // NOTE: Could be also layouted by setting directly rootFlexContainer.frame
        // The root container contains essentially the whole UI
        rootFlexContainer.pin.top().horizontally().margin(pin.safeArea)
        
        // The camera view lies underneath the UI flex container
        cameraView.pin.top().horizontally()
        
        // Then let the flexbox container layout itself
        rootFlexContainer.flex.layout(mode: .adjustHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
