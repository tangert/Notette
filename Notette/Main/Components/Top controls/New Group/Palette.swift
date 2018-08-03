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

    // MARK: called every time state is updated
    func newState(state: AppState) {
        
        dataProvider.data = mainStore.state.colorNoteData
        
        DispatchQueue.main.async {
            self.dataProvider.reloadData()
        }
    }
    
    
    // MARK: Adding subviews
    init() {
        super.init(frame: .zero)
        mainStore.subscribe(self)
        
        // Size constants
        let cellWidth = 35

        let viewProvider = ClosureViewProvider(viewUpdater: { (cell: PaletteCell, data: ColorNote, index: Int) in
            
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
    
    // MARK: Button event handlers
    @objc func onClick(sender: UIButton) {
        print("Note clicked")
    }
    
    // MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
