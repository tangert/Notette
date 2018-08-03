//
//  Timer+Extensions.swift
//  Notette
//
//  Created by Tyler Angert on 8/3/18.
//  Copyright © 2018 Tyler Angert. All rights reserved.
//

import Foundation

extension Timer {
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time( dispatch_time_t(DISPATCH_TIME_NOW), Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
}
