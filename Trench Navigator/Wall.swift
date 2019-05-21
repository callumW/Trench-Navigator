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
    
    init(scene: GameScene, position: CGPoint, size: CGSize) {
        self.scene = scene
        sprite = SKShapeNode(rectOf: size)
        sprite.strokeColor = SKColor.green
        sprite.fillColor = SKColor.green
        sprite.position = position
        self.scene.addChild(sprite)
    }
    
    deinit {
        if sprite.parent != nil {
            sprite.removeFromParent()
        }
    }
    
}
