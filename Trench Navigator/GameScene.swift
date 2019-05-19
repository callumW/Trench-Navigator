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
    var waypointPath: WaypointPath!
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        
        player.position = CGPoint(x: player.size.height / 2, y: size.height * 0.5)
        player.zRotation = CGFloat.pi * 1.5;
        
        addChild(player)
        
        self.waypointPath = WaypointPath(self, player: player)
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
        self.waypointPath.addWaypoint(point: point)
    }
    
    override func didEvaluateActions() {
        self.waypointPath.updateLineLength()
    }
}
