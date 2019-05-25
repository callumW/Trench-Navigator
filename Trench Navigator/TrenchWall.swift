//
//  TrenchWall.swift
//  Trench Navigator
//
//  Created by Callum Wilson on 25/05/2019.
//  Copyright © 2019 Callum Wilson. All rights reserved.
//

import Foundation
import CoreGraphics
import SpriteKit

enum Side {
    case TOP
    case BOTTOM
}

class TrenchWall {
    static let WALL_HEIGHT_RANGE: Double = 30
    static let MAX_WALL_SECTION_LENGTH: Double = 15
    static let MIN_WALL_SECTION_LENGTH: Double = 10
    let side: Side
    var points: [CGPoint]
    var numPoints: Int = 0
    let yOffset: Double
    let scene: GameScene
    let sprite: SKShapeNode
    
    init(scene: GameScene, side: Side) {
        self.scene = scene
        self.side = side
        var wallMidLine: Double = 0.0
        
        switch side {
        case .TOP:
            yOffset = Double(scene.size.height) - TrenchWall.WALL_HEIGHT_RANGE * 0.5
            wallMidLine = Double(scene.size.height) - TrenchWall.WALL_HEIGHT_RANGE / 2.0
            points = [
                CGPoint(x: 0.0, y: Double(scene.size.height)),
                CGPoint(x: Double(scene.size.width), y: Double(scene.size.height))
            ]
            break
        case .BOTTOM:
            yOffset = TrenchWall.WALL_HEIGHT_RANGE * 1.5
            wallMidLine = TrenchWall.WALL_HEIGHT_RANGE / 2.0
            points = [
                CGPoint(x: 0.0, y: 0.0),
                CGPoint(x: Double(scene.size.width), y: 0.0)
            ]
            break;
        }

        var startX = Double(scene.size.width)
        while startX >= 0 {
            let nextPoint = CGPoint(x: startX, y: yOffset - Double.random(in: 0.0...TrenchWall.WALL_HEIGHT_RANGE))
            points.append(nextPoint)
            numPoints += 1
            startX -= Double.random(in: TrenchWall.MAX_WALL_SECTION_LENGTH...TrenchWall.MAX_WALL_SECTION_LENGTH)
        }
        
        points.append(CGPoint(x: 0.0, y: yOffset - Double.random(in: 0.0...TrenchWall.WALL_HEIGHT_RANGE)))
        points.append(points[0])
        
        sprite = SKShapeNode(points: &points, count: points.count)
        sprite.strokeColor = SKColor.green
        sprite.fillColor = SKColor.green
        scene.addChild(sprite)
    }
    
    deinit {
        if sprite.parent != nil {
            sprite.removeFromParent()
        }
    }
}
