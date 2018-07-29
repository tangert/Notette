//
//  DependenciesContainer.swift
//  Notette
//
//  Created by Tyler Angert on 7/28/18.
//  Copyright © 2018 Tyler Angert. All rights reserved.
//

import Katana
import Tempura

final class DependenciesContainer: NavigationProvider {
    
    let dispatch: StoreDispatch
    
    var getAppState: () -> AppState
    
    var navigator: Navigator = Navigator()
    
    var getState: () -> State {
        return self.getAppState
    }
    
    required init(dispatch: @escaping StoreDispatch, getAppState: @escaping () -> AppState) {
        self.dispatch = dispatch
        self.getAppState = getAppState
    }
}

extension DependenciesContainer {
    convenience init(dispatch: @escaping StoreDispatch, getState: @escaping () -> State) {
        let getAppState: () -> AppState = {
            guard let state = getState() as? AppState else {
                fatalError("Wrong State Type")
            }
            return state
        }
        
        self.init(dispatch: dispatch, getAppState: getAppState)
    }
}
