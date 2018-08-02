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
import ReSwift

class MainInterface_ViewModel: UIView {
    
    fileprivate let rootFlexContainer = UIView()
    fileprivate let cameraView = CameraView(frame: UIScreen.main.bounds)
    
    var topControls: TopControls!
    var keyboard: Keyboard!
    
    init() {
        super.init(frame: .zero)
            
        // Declaritively lay out subviews
        topControls = TopControls()
        keyboard = Keyboard()
        
        rootFlexContainer.flex.direction(.column).padding(20).define { (flex) in
            flex.addItem(topControls)
            flex.addItem(keyboard).marginTop(-20)
        }
        
        addSubview(cameraView)              // Add camera view first
        addSubview(rootFlexContainer)       // Add overlaying UI
    }
    
    // MARK: New state
    func gotNewState(state: AppState) {
    }
    
    // MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Layout the flexbox container using PinLayout
        // NOTE: Could be also layouted by setting directly rootFlexContainer.frame
        // The root container contains essentially the whole UI
        rootFlexContainer.pin.top().horizontally().margin(pin.safeArea)
        cameraView.pin.top().horizontally()
        
        // Then let the flexbox container layout itself
        rootFlexContainer.flex.layout(mode: .adjustHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
