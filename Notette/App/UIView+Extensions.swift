//
//  UIView+Extensions.swift
//  Notette
//
//  Created by Tyler Angert on 8/1/18.
//  Copyright © 2018 Tyler Angert. All rights reserved.
//

import Foundation
import UIKit

// Add a rudimentary "props" type behavior
// A propsSource
protocol propsSource {
    func didReceiveProps(props: Any)
}
