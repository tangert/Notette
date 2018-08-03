//
//  Array+Extensions.swift
//  Notette
//
//  Created by Tyler Angert on 8/1/18.
//  Copyright © 2018 Tyler Angert. All rights reserved.
//

import Foundation

extension Array {
    func randomItem() -> Element? {
        if isEmpty { return nil }
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}

extension Set {
    func toArray() -> Array<Any> {
        return Array(self)
    }
}
