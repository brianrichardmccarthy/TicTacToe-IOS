//
//  Constants.swift
//  NaughtsAndCrosses
//
//  Created by Brian McCarthy on 04/12/2017.
//  Copyright © 2017 Brian McCarthy. All rights reserved.
//

import SpriteKit
import GameplayKit

class Constants {

    static let backgroundColor: SKColor = SKColor(red: 189.0/255.0, green: 209.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    // static let buttonColor: SKColor = SKColor(red: 214.0/255.0, green: 227.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    static let buttonColorPressed: SKColor = SKColor(red: (189.0/2)/255.0, green: (209.0/2)/255.0, blue: 127.0/255.0, alpha: 1.0)
    
    static let fontColor: SKColor = SKColor.black
    static let fontFamily: String = "Arial"
    
    static let back: String = "< Back"
    static let normal: String = "Normal"
    static let misere: String = "Misere"
    static let revenge: String = "Revenge"
    
    static let numerical: String = "Numerical"
    static let sos: String = "SOS"
    
    static let player1_ID: Int = 0
    static let player2_ID: Int = 1
    
    static let WIN_SCORE: Float = 100
    static let DRAW_SCORE: Float = 0

    static func loadMainMenu(controller: UIViewController) {
        let scene = MainMenuScene(size: controller.view.bounds.size)
        scene.setController(controller: controller)
        let skView = controller.view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
    }
    
    static func loadGame(controller: UIViewController, game: GAME_MODE) {
        let scene = GameScene(size: controller.view.bounds.size)
        scene.setGame(gameMode: game)
        scene.setController(controller: controller)
        let skView = controller.view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
    }
    
    static func gameOver(board: [[SLOT]]) -> Bool {
        for row in 0 ... 2 {
            for col in 0 ... 2 {
                if (board[row][col] == SLOT.EMPYT) { return false }
            }
        }
        return true
    }
    
}
