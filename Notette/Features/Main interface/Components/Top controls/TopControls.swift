//
//  TopControls.swift
//  Notette
//
//  Created by Tyler Angert on 7/30/18.
//  Copyright © 2018 Tyler Angert. All rights reserved.
//

import Foundation
import UIKit

// Composed of:
//      1. Key selector
//      2. Palette

class TopControls: UIView {
    
    // MARK: Subviews
    var keySelector = KeySelector()
    var palette = Palette()
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
