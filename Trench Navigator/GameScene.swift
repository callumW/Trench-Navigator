//
//  GameScene.swift
//  Trench Navigator
//
//  Created by Callum Wilson on 16/05/2019.
//  Copyright © 2019 Callum Wilson. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    let player = SKSpriteNode(imageNamed: "Submarine")
    
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white
        
        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        
        addChild(player)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            print("failed to get touch in touchesEnd()")
            return
        }
        
        let touchLocation = touch.location(in: self)
        
        addWaypoint(touchLocation)
    }
    
    /*
        Add waypoint to player path
    */
    func addWaypoint(_ point: CGPoint) {
        player.run(SKAction.sequence([SKAction.move(to: point, duration: 1.0)]))
    }
}
