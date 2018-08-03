//
//  UIView+Extensions.swift
//  Notette
//
//  Created by Tyler Angert on 8/2/18.
//  Copyright © 2018 Tyler Angert. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    var globalPoint :CGPoint? {
        return self.superview?.convert(self.frame.origin, to: nil)
    }
    
    var globalFrame :CGRect? {
        return self.superview?.convert(self.frame, to: nil)
    }
}
