//
//  CustomButton.swift
//  NaughtsAndCrosses
//
//  Created by Brian McCarthy on 09/12/2017.
//  Copyright © 2017 Brian McCarthy. All rights reserved.
//

import Foundation
import SpriteKit

protocol ButtonDelegate: class {
    func buttonPressed(_ button: CustomButton)
}

class CustomButton : SKSpriteNode {
    
    weak var delegate: ButtonDelegate?
    
    init(scene: SKScene, labelName: String) {
        super.init(texture: nil, color: Constants.backgroundColor, size: CGSize(width: CGFloat(100.0), height: CGFloat(70.0)))
        self.isUserInteractionEnabled = true
        self.position = CGPoint(x: scene.size.width*0.05, y: scene.size.height*0.95)
        
        scene.addChild(self)
        
        let back = SKLabelNode(fontNamed: Constants.fontFamily)
        back.text = labelName
        back.fontSize = 25
        back.fontColor = Constants.fontColor
        back.position = CGPoint(x: position.x+3, y: position.y-10)
        
        scene.addChild(back)
    }
    
    init(scene: SKScene, labelName: String, pos: CGPoint, size: CGSize) {
        super.init(texture: nil, color: Constants.backgroundColor, size: size)
        self.isUserInteractionEnabled = true
        self.position = pos
        
        scene.addChild(self)
        
        let back = SKLabelNode(fontNamed: Constants.fontFamily)
        back.text = labelName
        back.fontSize = 25
        back.fontColor = Constants.fontColor
        back.position = CGPoint(x: position.x+3, y: position.y-10)
        
        scene.addChild(back)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func touchUp(atPoint pos: CGPoint) {
        
        if (contains(pos)) {
            delegate?.buttonPressed(self)
        }
        
        color = Constants.backgroundColor
        
    }
    
    func touchDown(atPoint pos: CGPoint) {
        color = Constants.buttonColorPressed
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if parent != nil {
                self.touchDown(atPoint: touch.location(in: parent!))
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // print("Button Touches Ended")
        for touch in touches {
            if parent != nil {
                self.touchUp(atPoint: touch.location(in: parent!))
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if parent != nil {
                self.touchUp(atPoint: touch.location(in: parent!))
            }
        }
    }
    
}
