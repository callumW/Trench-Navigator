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

class TrenchWall: Hittable {
    static let WALL_HEIGHT_RANGE: Double = 30
    static let MAX_WALL_SECTION_LENGTH: Double = 15
    static let MIN_WALL_SECTION_LENGTH: Double = 10

    let side: Side
    let yOffset: Double
    let scene: GameScene
    let sprite: SKShapeNode
    
    var maxWallHeight = 0.0
    var points: [CGPoint]
    
    init(scene: GameScene, side: Side) {
        self.scene = scene
        self.side = side
        
        switch side {
        case .TOP:
            yOffset = Double(scene.size.height) - TrenchWall.WALL_HEIGHT_RANGE * 0.5
            points = [
                CGPoint(x: 0.0, y: Double(scene.size.height)),
                CGPoint(x: Double(scene.size.width), y: Double(scene.size.height))
            ]
            break
        case .BOTTOM:
            yOffset = TrenchWall.WALL_HEIGHT_RANGE * 1.5
            points = [
                CGPoint(x: 0.0, y: 0.0),
                CGPoint(x: Double(scene.size.width), y: 0.0)
            ]
            break;
        }

        var startX = Double(scene.size.width)
        while startX > 0.0 {
            startX -= Double.random(in: TrenchWall.MAX_WALL_SECTION_LENGTH...TrenchWall.MAX_WALL_SECTION_LENGTH)
            
            if startX <= 0.0 {
                startX = 0.0
            }
            
            let wallHeight = Double.random(in: 0.0...TrenchWall.WALL_HEIGHT_RANGE)
            let nextPoint = CGPoint(x: startX, y: yOffset - wallHeight)
            
            if side == .TOP {
                if maxWallHeight < wallHeight {
                    maxWallHeight = wallHeight
                }
            }
            else {
                if maxWallHeight > wallHeight {
                    maxWallHeight = wallHeight
                }
            }
            points.append(nextPoint)
        }
        
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
    
    func doesCollide(waypoint: Waypoint) -> Bool {
        let waypointLine = waypoint.toLine()

        /*
            Check if line is anywhere close to TrenchWall
        */
        switch self.side {
        case .TOP:
            if waypointLine.maxY < self.yOffset - maxWallHeight {
                return false
            }
            break;
        case .BOTTOM:
            if waypointLine.minY > self.yOffset - maxWallHeight {
                return false
            }
            break;
        }
        
        var lastPoint = self.points[0]
        for i in 1..<self.points.count {
            let point = self.points[i]
            let line = Line(a: lastPoint, b: point)
            
            if waypointLine.doesIntersect(line: line) {
                return true
            }
            lastPoint = point
        }
        
        return false
    }
}
