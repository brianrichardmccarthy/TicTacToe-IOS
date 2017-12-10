//
//  MainMenuScene.swift
//  NaughtsAndCrosses
//
//  Created by Brian McCarthy on 09/12/2017.
//  Copyright © 2017 Brian McCarthy. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene, ButtonDelegate {
    
    var controller: UIViewController!
    var normal: CustomButton!
    var misere: CustomButton!
    var revenge: CustomButton!
    
    //MARK: - ButtonDelegate
    func buttonPressed(_ button: CustomButton) {
        switch button {
        case normal:
            Constants.loadGame(controller: controller, game: .NORMAL)
            break
        case misere:
            Constants.loadGame(controller: controller, game: .MISERE)
            break
        case revenge:
            Constants.loadGame(controller: controller, game: .REVENGE)
            break
        default: break
        }
    }
    
    func setController(controller: UIViewController) {
        self.controller = controller
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = Constants.backgroundColor
        normal = CustomButton(scene: self, labelName: Constants.normal, pos: CGPoint(x: size.width/2, y:size.height*0.7), size: CGSize(width: CGFloat(150.0), height: CGFloat(100.0)))
        misere = CustomButton(scene: self, labelName: Constants.misere, pos: CGPoint(x: size.width/2, y:size.height*0.5), size: CGSize(width: CGFloat(150.0), height: CGFloat(100.0)))
        revenge = CustomButton(scene: self, labelName: Constants.revenge, pos: CGPoint(x: size.width/2, y:size.height*0.3), size: CGSize(width: CGFloat(150.0), height: CGFloat(100.0)))
        
        normal.delegate = self
        misere.delegate = self
        revenge.delegate = self
    }
    
}
