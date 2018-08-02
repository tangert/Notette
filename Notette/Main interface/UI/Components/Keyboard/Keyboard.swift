//
//  Keyboard.swift
//  Notette
//
//  Created by Tyler Angert on 7/30/18.
//  Copyright © 2018 Tyler Angert. All rights reserved.
//

import Foundation
import UIKit
import CollectionKit
import ReSwift
import PinLayout

class Keyboard: CollectionView, StoreSubscriber {
    
    // MARK: called every time state is updated
    // The keyboard's cells are updated with the new relevant notes
    func newState(state: AppState) {
    }
    
    // MARK: Adding subviews
    init() {
        super.init(frame: .zero)
        mainStore.subscribe(self)

        
//        backgroundColor = UIColor.white
        
        // Size constants
        let cellWidth = 35
        
        // Get these actual measurements
        // From the rest of the flex container...
        let width = Int(UIScreen.main.bounds.width)
        let height = Int(UIScreen.main.bounds.height - (UIScreen.main.bounds.height)*0.2)
        
        let interItemSpace = 10
        let cellSpace = cellWidth + interItemSpace
        
        let numberOfColumns = width/cellSpace
        let numberOfRows = height/cellSpace
        
        print("Num cols: \(numberOfColumns)")
        print("Num rows: \(numberOfRows)")
        
        // First create the rows
        let gridData = Array.init(repeating: 1, count: Int(numberOfRows * numberOfColumns))
        
        let dataProvider = ArrayDataProvider.init(data: gridData)
        
        let viewProvider = ClosureViewProvider(viewUpdater: { (cell: KeyboardCell, data: Int, index: Int) in
            cell.tag = index
        })
        
        let sizeProvider = { (index: Int, data: Int, collectionSize: CGSize) -> CGSize in
            return CGSize(width: cellWidth, height: cellWidth)
        }
        
        
        let provider = CollectionProvider(dataProvider: dataProvider,
                                          viewProvider: viewProvider,
                                          sizeProvider: sizeProvider)
        
        // Layout and spacing
        provider.layout = FlowLayout(lineSpacing: CGFloat(interItemSpace),
                                     interitemSpacing: CGFloat(interItemSpace),
                                     justifyContent: .end,
                                     alignItems: .start,
                                     alignContent: .start)
        
        self.provider = provider
        self.isScrollEnabled = false
        
        self.frame = CGRect(x: 0,
                            y: 0,
                            width: CGFloat(width),
                            height: CGFloat(height) + CGFloat(cellSpace))
        
        // MARK: Pan gesture recognizer to send data to the children
        // Detect touches in the keyboard
        // Send location to each of the 
    }
    
    // MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
