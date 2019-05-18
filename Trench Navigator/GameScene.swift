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
        
        player.position = CGPoint(x: player.size.height / 2, y: size.height * 0.5)
        player.zRotation = CGFloat.pi * 1.5;
        
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
        
        // workout orientation for player
        let adjacent = player.position.x - point.x
        let oposite = player.position.y - point.y
        
        let angle = atan2(oposite, adjacent) + 90 * (CGFloat.pi / 180)
        
        let rotateAction = SKAction.rotate(toAngle: angle, duration: 0.3, shortestUnitArc: true)    // let swift choose the direction to rotate
        
        let moveAction = SKAction.move(to: point, duration: 1.0)
        
        player.run(SKAction.sequence([rotateAction, moveAction]))
    }
}
