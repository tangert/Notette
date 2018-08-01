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

class Palette: CollectionView {
    
    // MARK: Adding subviews
    init() {
        super.init(frame: .zero)
        
        // Size constants
        let cellWidth = 25
        
        let dataProvider = ArrayDataProvider(data: [1,2,3,4,5,6,7,8])
        
        let viewProvider = ClosureViewProvider(viewUpdater: { (button: UIButton, data: Int, index: Int) in
            
            // Pass in the proper color and text
            // from the current chosen scale
            button.backgroundColor = .red
            button.titleLabel?.text = "\(data)"

            // shadows and stuff
            
            // Other setup
            button.layer.cornerRadius = 5
            button.clipsToBounds = true
            button.titleLabel?.textAlignment = .center
            
            
            // Event handling
            button.tag = index
            button.addTarget(self, action: #selector(self.onClick(sender:)), for: UIControlEvents.touchUpInside)
    
        })
        
        let sizeProvider = { (index: Int, data: Int, collectionSize: CGSize) -> CGSize in
            return CGSize(width: cellWidth, height: cellWidth)
        }

        // Construct the provider
        let provider = CollectionProvider(
            dataProvider: dataProvider,
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
                            width: (( cellWidth * 2) * (dataProvider.data.count)),
                            height: cellWidth*2)
    }
    
    // MARK: Button event handlers
    @objc func onClick(sender: UIButton) {
        print("\nClicked: \(sender.tag)")
        // switch the events to the store based on the tag of the button
    }
    
    // MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
