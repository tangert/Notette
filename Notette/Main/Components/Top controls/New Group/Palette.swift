//
//  Palette.swift
//  Notette
//
//  Created by Tyler Angert on 7/31/18.
//  Copyright © 2018 Tyler Angert. All rights reserved.
//

import Foundation
import UIKit
import CollectionKit
import ReSwift
import MusicTheorySwift

class Palette: CollectionView, StoreSubscriber {
    
    var dataProvider = ArrayDataProvider<ColorNote>(data: mainStore.state.colorNoteData)
    var previousColors = mainStore.state.colors // initialize previous colors to avoid unnecessary state changes

    // MARK: called everytime there's a new palette
    func newState(state: AppState) {
        if state.colors != previousColors {
            DispatchQueue.main.async {
                self.dataProvider.data = mainStore.state.colorNoteData
                self.previousColors = state.colors
            }
        }
    }
    
    
    // MARK: Adding subviews
    init() {
        super.init(frame: .zero)
        mainStore.subscribe(self)
        setupCollectionView()
    }
    
    // MARK: Button event handlers
    @objc func onClick(sender: UIButton) {
        print("Note clicked")
    }
    
    // MARK: Layout
    
    func setupCollectionView() {
        
        // Size constants
        let cellWidth = 35
        
        let viewProvider = ClosureViewProvider(viewUpdater: { (cell: PaletteCell_View, data: ColorNote, index: Int) in
            
            cell.populate(data: data)
            cell.tag = index
            cell.addTarget(self, action: #selector(self.onClick(sender:)), for: UIControlEvents.touchUpInside)
            
        })
        
        let sizeProvider = { (index: Int, data: ColorNote, collectionSize: CGSize) -> CGSize in
            return CGSize(width: cellWidth, height: cellWidth)
        }
        
        
        let provider = CollectionProvider(dataProvider: dataProvider,
                                          viewProvider: viewProvider,
                                          sizeProvider: sizeProvider)
        
        // Layout and spacing
        provider.layout = FlowLayout(lineSpacing: 10,
                                     interitemSpacing: 10,
                                     justifyContent: .end,
                                     alignItems: .start,
                                     alignContent: .start)
        
        self.provider = provider
        self.frame = CGRect(x: 0,
                            y: 0,
                            width: (( cellWidth * 2) * 8),
                            height: cellWidth*2)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
