//
//  MainInterface_ViewController.swift
//  Notette
//
//  Created by Tyler Angert on 7/29/18.
//  Copyright © 2018 Tyler Angert. All rights reserved.
//

import Foundation
import UIKit

class MainInterface_ViewController: UIViewController {
    
    fileprivate var mainView: MainInterface_ViewModel {
        return self.view as! MainInterface_ViewModel
    }
    
    override func loadView() {
        view = MainInterface_ViewModel()
    }

}
