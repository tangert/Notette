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

class Keyboard: CollectionView, Touchable, StoreSubscriber {
    
    // MARK: Touch delegate info
    var touchDelegate: TouchDelegate?
    var mainView: CollectionView!
    var previouslyTouchedCells = Set<Int>()
    
    // MARK: Synth!
    static let synth = Synthesizer()
    
    // MARK: Setup
    init() {
        super.init(frame: .zero)
        
        // MARK: Get store updates
        mainStore.subscribe(self)
        
        // Initialize touch handler for delegated actions
        let _ = TouchHandler(delegateTarget: self)
        
        // Setup synth
        Keyboard.synth.startEngine()
        
        // Setup the collection view layout
        setupCollectionView()
        
        isMultipleTouchEnabled = true
    }
    
    // MARK: State listener
    func newState(state: AppState) {
        
        // need to check if the current touched and previous touched are NOT the same
        // if they are, then
        
        if state.userIsTouchingKeyboard {
            updateCells(state: state)
        }
    }
    
    var pressCount = 0
    
    // Update the visual state in the grid
    func updateCells(state: AppState) {
        
        let touched = Set(state.touchedKeyboardCells)
        let released = Set(state.releasedKeyboardCells)
        
        if touched != previouslyTouchedCells {
            for t in touched {
                let cell = self.cell(at: t) as! KeyboardCell_View
                    print("PRESS COUNT: \(pressCount)")
                    cell.setState(state: .pressed)
                    pressCount += 1
            }
        }
        
        for r in released {
            let cell = self.cell(at: r) as! KeyboardCell_View
            cell.setState(state: .notPressed)
        }
        
        previouslyTouchedCells = Set(touched)
    }
    
    // MARK: Layout
    func setupCollectionView() {
        
        // Size constants
        let cellWidth = mainStore.state.keyBoardCellWidth
        
        // Get these actual measurements
        // From the rest of the flex container...
        let heightOffset = 140
        let width = Int(UIScreen.main.bounds.width)
        let height = Int(UIScreen.main.bounds.height) - heightOffset
        
        let interItemSpace = 10
        let cellSpace = cellWidth + interItemSpace
        
        let numberOfColumns = width/cellSpace
        let numberOfRows = (height/cellSpace)
        
        // First create the rows
        let gridData = Array.init(repeating: 1, count: Int(numberOfRows * numberOfColumns))
        
        let dataProvider = ArrayDataProvider.init(data: gridData)
        
        let viewProvider = ClosureViewProvider(viewUpdater: { (cell: KeyboardCell_View, data: Int, index: Int) in
            cell.tag = index
        })
        
        let sizeProvider = { (index: Int, data: Int, collectionSize: CGSize) -> CGSize in
            return CGSize(width: cellWidth, height: cellWidth)
        }
        
        // Compile
        let provider = CollectionProvider(dataProvider: dataProvider,
                                          viewProvider: viewProvider,
                                          sizeProvider: sizeProvider)
        
        // Layout and spacing
        provider.layout = FlowLayout(lineSpacing: CGFloat(interItemSpace),
                                     interitemSpacing: CGFloat(interItemSpace),
                                     justifyContent: .spaceAround,
                                     alignItems: .start,
                                     alignContent: .spaceAround)
        
        self.provider = provider
        self.mainView = self.provider.collectionView
        self.isScrollEnabled = false
        
        self.frame = CGRect(x: 0,
                            y: 0,
                            width: CGFloat(width),
                            height: CGFloat(height) + CGFloat(cellSpace))
        
    }
    
    // MARK: Touch events
    // Send to delegate to avoid clutter
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchDelegate?.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchDelegate?.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchDelegate?.touchesEnded(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        guard let touches = touches else { return }
        touchDelegate?.touchesCancelled(touches, with: event)
    }
    
    // MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
