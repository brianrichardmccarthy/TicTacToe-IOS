//
//  GameScene.swift
//  NaughtsAndCrosses
//
//  Created by Brian McCarthy on 04/12/2017.
//  Copyright © 2017 Brian McCarthy. All rights reserved.
//

import SpriteKit
import GameplayKit

enum GAME_MODE {
    case NORMAL, MISERE, NUMERICAL, REVENGE, SOS
}

class GameScene: SKScene, ButtonDelegate {
    
    let player = SKSpriteNode(imageNamed: "X")
    let computer = SKSpriteNode(imageNamed: "O")
    var game: Game!
    var initalPosition: CGPoint!
    var boardBoxes: [BoardBox]!
    var board = SKSpriteNode(imageNamed: "board")
    var newPosition: CGPoint!
    var nextIndex: Int = -1
    var back: CustomButton!
    var controller: UIViewController!
    var gameMode : GAME_MODE!
    
    func setGame(gameMode: GAME_MODE) {
        self.gameMode = gameMode
        switch gameMode {
        case .NORMAL:
            game = Normal()
            break
        case .MISERE:
            game = Misere()
            break
        case .NUMERICAL: break
        case .REVENGE :
            game = Revenge()
            break
        case .SOS: break
        }
    }
    
    func setController(controller: UIViewController) {
        self.controller = controller
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = Constants.backgroundColor
        // print(gameMode)
        
        boardBoxes = [
            BoardBox(bounds: CGRect(x: CGFloat(size.width*0.02), y: CGFloat(size.height*0.685), width: CGFloat(size.width*0.28), height: CGFloat(size.height*0.15))),
            BoardBox(bounds: CGRect(x: CGFloat(size.width*0.35), y: CGFloat(size.height*0.685), width: CGFloat(size.width*0.28), height: CGFloat(size.height*0.15))),
            BoardBox(bounds: CGRect(x: CGFloat(size.width*0.68), y: CGFloat(size.height*0.685), width: CGFloat(size.width*0.28), height: CGFloat(size.height*0.15))),
            
            BoardBox(bounds: CGRect(x: CGFloat(size.width*0.02), y: CGFloat(size.height*0.515), width: CGFloat(size.width*0.28), height: CGFloat(size.height*0.15))),
            BoardBox(bounds: CGRect(x: CGFloat(size.width*0.355), y: CGFloat(size.height*0.515), width: CGFloat(size.width*0.28), height: CGFloat(size.height*0.15))),
            BoardBox(bounds: CGRect(x: CGFloat(size.width*0.68), y: CGFloat(size.height*0.515), width: CGFloat(size.width*0.28), height: CGFloat(size.height*0.15))),
            
            BoardBox(bounds: CGRect(x: CGFloat(size.width*0.02), y: CGFloat(size.height*0.36), width: CGFloat(size.width*0.28), height: CGFloat(size.height*0.15))),
            BoardBox(bounds: CGRect(x: CGFloat(size.width*0.355), y: CGFloat(size.height*0.36), width: CGFloat(size.width*0.28), height: CGFloat(size.height*0.15))),
            BoardBox(bounds: CGRect(x: CGFloat(size.width*0.68), y: CGFloat(size.height*0.36), width: CGFloat(size.width*0.28), height: CGFloat(size.height*0.15)))]
        
        board.position = CGPoint(x: size.width * 0.5, y: size.height * 0.6)
        
        initalPosition = CGPoint(x: size.width * 0.3, y: size.height * 0.2)
        player.position = initalPosition
        
        computer.position = CGPoint(x: size.width * 0.6, y: size.height * 0.2)
        
        addChild(board)
        addChild(player)
        addChild(computer)
        back = CustomButton(scene: self, labelName: Constants.back)
        back.delegate = self
        
        newPosition = CGPoint(x: -1, y: -1)
    }
    
    //MARK: - ButtonDelegate
    func buttonPressed(_ button: CustomButton) {
        switch button {
        case back:
            Constants.loadMainMenu(controller: self.controller)
        default:
            break
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if (touch.location(in: self).y < boardBoxes[0].bounds.origin.y+boardBoxes[0].bounds.size.height) {
                newPosition = touch.location(in: self)
                player.position = newPosition
            }
        }
        // print("Input detected")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if (touch.location(in: self).y < boardBoxes[0].bounds.origin.y+boardBoxes[0].bounds.size.height) {
                newPosition = touch.location(in: self)
                player.position = newPosition
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.position = initalPosition
        
        if (game.getCurrentUser() != SLOT.PLAYER_1) { return }
        
        var index: Int = 0
        
        while (index < boardBoxes.count) {
            if (boardBoxes[index].overlap(point: newPosition) && boardBoxes[index].slot == SLOT.EMPYT) {
                let nextMove = SKSpriteNode(imageNamed: "X")
                nextMove.position = newPosition
                addChild(nextMove)
                boardBoxes[index].slot = SLOT.PLAYER_1
                nextIndex = index
                break
            }
            index += 1
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        // print(game.toString())
        
        if (!game.gameOver()) {
            if (game.getCurrentUser() == SLOT.PLAYER_1) {
                if (game.move(index: nextIndex)) { nextIndex = -1 }
                computer.alpha = CGFloat(0.5)
                player.alpha = CGFloat(1.0)
            } else {
                computer.alpha = CGFloat(1.0)
                player.alpha = CGFloat(0.5)
                run(SKAction.sequence(
                    [
                        SKAction.wait(forDuration: 3.0),
                    ]
                ))
                game.getMove()
            }
        } else {
            
            var win: Int!
            
            switch game.getState() {
            case STATE.PLAYER_1_WON:
                win = 1
                break
            case STATE.PLAYER_2_WON:
                win = -1
                break
            default:
                win = 0
                break
            }
            
            run(SKAction.sequence(
                [
                    SKAction.run {
                        let reveal = SKTransition.flipVertical(withDuration: 0.5)
                        let scene = GameOverScene(size: self.size, won: win, controller: self.controller, gameMode: self.gameMode)
                        self.view?.presentScene(scene, transition:reveal)
                    }
                ]
            ))
        }
        
        let b = game.getBoard()
        var index: Int = 0
        for r in b {
            for c in r {
                if (c == SLOT.PLAYER_2 && !boardBoxes[index].isDrawn) {
                    boardBoxes[index].slot = SLOT.PLAYER_2
                    boardBoxes[index].isDrawn = true
                    let sprite = SKSpriteNode(imageNamed: "O")
                    sprite.position = CGPoint(x: boardBoxes[index].bounds.origin.x + (boardBoxes[index].bounds.size.width/2), y:boardBoxes[index].bounds.origin.y + (boardBoxes[index].bounds.size.height/2));
                    addChild(sprite)
                }
                index += 1
            }
        }
    }
}
