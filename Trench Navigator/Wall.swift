//
//  Wall.swift
//  Trench Navigator
//
//  Created by Callum Wilson on 21/05/2019.
//  Copyright © 2019 Callum Wilson. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class Wall {
    var sprite: SKShapeNode! = nil
    var scene: GameScene! = nil
    let collisionRect: CGRect
    var colSprite: SKShapeNode! = nil
    
    init(scene: GameScene, position: CGPoint, size: CGSize) {
        self.scene = scene
        collisionRect = CGRect(x: position.x - size.width / 2, y: position.y - size.height / 2, width: size.width, height: size.height)
        sprite = SKShapeNode(rectOf: size)
        sprite.strokeColor = SKColor.green
        sprite.fillColor = SKColor.green
        sprite.position = position
        self.scene.addChild(sprite)
        
        colSprite = SKShapeNode(rect: collisionRect)
        colSprite.strokeColor = SKColor.red
        self.scene.addChild(colSprite)
        
    }
    
    convenience init(scene: GameScene, position: CGPoint) {
        self.init(scene: scene, position: position, size: CGSize(width: 40, height: 40))
    }
    
    deinit {
        if sprite.parent != nil {
            sprite.removeFromParent()
        }
        if colSprite.parent != nil {
            colSprite.removeFromParent()
        }
    }
    
    func willCollide(waypoint: Waypoint) -> Bool {
        let line = waypoint.toLine()
        return line.doesIntersect(rect: self.collisionRect)
    }
    
}
