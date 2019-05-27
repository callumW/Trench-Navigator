//
//  RockFormation.swift
//  Trench Navigator
//
//  Created by Callum Wilson on 26/05/2019.
//  Copyright © 2019 Callum Wilson. All rights reserved.
//

import Foundation
import CoreGraphics

func +(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

class RockFormation: PolyShape {
    var points: [CGPoint] = [CGPoint]()
    
    init(scene: GameScene) {
        let centerPoint = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
        
        // start with a square
        let baseShape: [CGPoint] = [
            CGPoint(x: -30, y: -30),
            CGPoint(x: 30, y: -30),
            CGPoint(x: 30, y: 30),
            CGPoint(x: -30, y: 30),
            CGPoint(x: -30, y: -30)
        ]
        
        for point in baseShape {
            points.append(point + centerPoint)
        }
    }
    
    func doesCollide(waypoint: Waypoint) -> Bool {
        return doesCollideWithShape(points: points, waypoint: waypoint)
    }
}
