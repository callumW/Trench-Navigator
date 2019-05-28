//
//  PolygonSprite.swift
//  Trench Navigator
//
//  Created by Callum Wilson on 26/05/2019.
//  Copyright © 2019 Callum Wilson. All rights reserved.
//

import Foundation
import CoreGraphics
import SpriteKit

func doesCollideWithShape(points: [CGPoint], waypoint: Waypoint) -> Bool {
    let waypointLine = waypoint.toLine()
    var lastPoint = points[0]
    for i in 1..<points.count {
        let point = points[i]
        let line = Line(a: lastPoint, b: point)
        
        if waypointLine.doesIntersect(line: line) {
            return true
        }
        lastPoint = point
    }
    
    return false
}

protocol PolyShape: Hittable {
    var points: [CGPoint] { get }
}

class PolygonSprite: Hittable {
    var points: [CGPoint]
    
    let shape: PolyShape
    let scene: GameScene
    let sprite: SKShapeNode
    
    init(scene: GameScene, shape: PolyShape) {
        self.scene = scene
        self.shape = shape
        self.points = self.shape.points
        self.sprite = SKShapeNode(points: &self.points, count: self.points.count)
        self.sprite.strokeColor = SKColor.red
        self.sprite.fillColor = SKColor.green
        scene.addChild(self.sprite)
    }
    
    deinit {
        if self.sprite.parent != nil {
            self.sprite.removeFromParent()
        }
    }
    
    func doesCollide(waypoint: Waypoint) -> Bool {
        return self.shape.doesCollide(waypoint: waypoint)
    }
}
