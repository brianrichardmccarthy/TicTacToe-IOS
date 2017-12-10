//
//  GameOverScene.swift
//  NaughtsAndCrosses
//
//  Created by Brian McCarthy on 09/12/2017.
//  Copyright © 2017 Brian McCarthy. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene : SKScene, ButtonDelegate {
    
    var back: CustomButton!
    var controller: UIViewController!
    var playAgain: CustomButton!
    var gameMode: GAME_MODE!
    
    init(size: CGSize, won:Int, controller: UIViewController, gameMode: GAME_MODE) {
        super.init(size: size)
        backgroundColor = Constants.backgroundColor
        
        var message: String = ""
        
        switch won {
        case 0:
            message = "It Was a Draw"
            break
        case 1:
            message = "You Won"
            break
        case -1:
            message = "You Lost"
            break
        default:
            break
        }
        
        self.gameMode = gameMode
        self.controller = controller
        
        let label = SKLabelNode(fontNamed: Constants.fontFamily)
        label.text = message
        label.fontSize = 30
        label.fontColor = Constants.fontColor
        label.position = CGPoint(x: size.width/2, y:size.height/2)
        addChild(label)
        
        back = CustomButton(scene: self, labelName: Constants.back)
        back.delegate = self
        
        playAgain = CustomButton(scene: self, labelName: "Play Again", pos: CGPoint(x: size.width*0.5, y: size.height*0.4), size: CGSize(width: CGFloat(120.0), height: CGFloat(100.0)))
        playAgain.delegate = self
    }
    
    func setController(controller: UIViewController) {
        self.controller = controller
    }
    
    //MARK: - ButtonDelegate
    func buttonPressed(_ button: CustomButton) {
        switch button {
        case back:
            Constants.loadMainMenu(controller: self.controller)
        case playAgain: Constants.loadGame(controller: self.controller, game: gameMode)
        default:
            break
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
