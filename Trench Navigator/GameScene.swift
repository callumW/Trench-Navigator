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
    var wall: Wall! = nil
    var topWall: PolygonSprite! = nil
    var bottomWall: PolygonSprite! = nil
    var rockFormation: PolygonSprite! = nil
    var collisionManager: CollisionManager! = nil
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        
        player.position = CGPoint(x: player.size.height / 2, y: size.height * 0.5)
        player.zRotation = CGFloat.pi * 1.5;
        
        addChild(player)
        
        self.collisionManager = CollisionManager(scene: self)
        
        self.waypointPath = WaypointPath(self, player: player, collisionManager: self.collisionManager)
        
        self.topWall = PolygonSprite(scene: self, shape: TrenchWall(scene: self, side: Side.TOP))
        self.bottomWall = PolygonSprite(scene: self, shape: TrenchWall(scene: self, side: Side.BOTTOM))
        self.rockFormation = PolygonSprite(scene: self, shape: RockFormation(scene: self))
        
        
        self.collisionManager.addObject(obj: self.topWall)
        self.collisionManager.addObject(obj: self.bottomWall)
        self.collisionManager.addObject(obj: self.rockFormation)
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
