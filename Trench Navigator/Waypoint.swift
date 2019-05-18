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
    
    var path: CGMutablePath = CGMutablePath()
    var line: SKShapeNode = SKShapeNode()
    var scene: GameScene!
    
    init(endPoint: CGPoint, startPoint: CGPoint, scene: GameScene) {
        self.endCircle.position = endPoint
        self.endCircle.fillColor = SKColor.green
        self.endCircle.strokeColor = SKColor.green
        self.scene = scene
        
        self.path.move(to: startPoint)
        self.path.addLine(to: endPoint)
        
        self.line.path = self.path
        self.line.strokeColor = SKColor.green
        self.line.lineWidth = 2

        scene.addChild(self.endCircle)
        scene.addChild(self.line)
    }
    
    func remove() {
        if endCircle.parent != nil {
            endCircle.removeFromParent()
        }
        
        if self.line.parent != nil {
            self.line.removeFromParent()
        }
    }
    
    func updateLine(_ newStartPoint: CGPoint) {
        
    }
}
