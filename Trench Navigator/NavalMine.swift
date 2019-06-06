//
//  NavalMine.swift
//  Trench Navigator
//
//  Created by Callum Wilson on 03/06/2019.
//  Copyright © 2019 Callum Wilson. All rights reserved.
//

import Foundation
import SpriteKit
import CoreGraphics

class NavalMine {
    let sprite: SKSpriteNode
    let dangerAreaSprite: SKShapeNode
    var currentTarget: CGPoint! = nil
    var lastUpdateTime: TimeInterval = 0
    var isInRange: Bool = false
    
    var position: CGPoint {
        didSet(newVal) {
            dangerAreaSprite.position = newVal
            sprite.position = newVal
        }
    }
    
    static let NAVAL_MINE_SPEED: CGFloat = 100.0
    static let NAVAL_MINE_RADIUS: CGFloat = 30.0
    
    init(scene: GameScene) {
        sprite = SKSpriteNode(imageNamed: "naval-mine")
        dangerAreaSprite = SKShapeNode(circleOfRadius: NavalMine.NAVAL_MINE_RADIUS)
        position = CGPoint(x: 300, y: 300)
        dangerAreaSprite.strokeColor = SKColor.red
        
        sprite.position = position
        dangerAreaSprite.position = position
        
        scene.addChild(sprite)
        scene.addChild(dangerAreaSprite)
    }
    
    deinit {
        if sprite.parent != nil {
            sprite.removeFromParent()
        }
        if dangerAreaSprite.parent != nil {
            dangerAreaSprite.removeFromParent()
        }
    }
    
    func moveTo(playerPosition: CGPoint, currentTime: TimeInterval) {
        // how far away from player are we?
        let distToTarget = distance(position, playerPosition)
        
        if distToTarget < NavalMine.NAVAL_MINE_RADIUS {
            // move to player
            if !isInRange {
                isInRange = true
                lastUpdateTime = currentTime
            }
            else {
                // distance to travel
                let deltaTime = currentTime - lastUpdateTime
                lastUpdateTime = currentTime
                
                let distTravelled = Double(NavalMine.NAVAL_MINE_SPEED) * deltaTime  // How far did mine travel
                
                let distRatio = distTravelled / Double(distToTarget)    // Ratio between
                let spacialRatio = CGPoint(x: 1.0, y: 1.0) - (position / playerPosition) // Ratio of distance between destination and origin
                
                position = position + (position * (spacialRatio * distRatio))
            }
        }
        else {
            isInRange = false
        }
    }
}
