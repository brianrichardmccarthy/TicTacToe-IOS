//
//  GameViewController.swift
//  NaughtsAndCrosses
//
//  Created by Brian McCarthy on 04/12/2017.
//  Copyright © 2017 Brian McCarthy. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Constants.loadMainMenu(controller: self)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
