//
//  Waypoint.swift
//  Trench Navigator
//
//  Created by Callum Wilson on 18/05/2019.
//  Copyright © 2019 Callum Wilson. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class Waypoint {
    var endCircle: SKShapeNode = SKShapeNode(circleOfRadius: 10)
    
    init(_ point: CGPoint) {
        endCircle.position = point
        endCircle.fillColor = SKColor.green
        endCircle.strokeColor = SKColor.green
    }
    
    func addTo(scene: GameScene) {
        scene.addChild(endCircle)
    }
    
    func remove() {
        if endCircle.parent != nil {
            endCircle.removeFromParent()
        }
    }
}
