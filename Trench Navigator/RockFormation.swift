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
    let centerPoint: CGPoint
    
    init(scene: GameScene) {
        centerPoint = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
        
        // start with a square
        let baseShape: [CGPoint] = [
            CGPoint(x: -30, y: -30),
            CGPoint(x: 30, y: -30),
            CGPoint(x: 30, y: 30),
            CGPoint(x: -30, y: 30),
            CGPoint(x: -30, y: -30)
        ]
        
        
        for i in 1..<baseShape.count {
            points.append(contentsOf: mutateLine(line: Line(a: baseShape[i-1], b: baseShape[i])))
        }
    }
    
    func mutateLine(line: Line) -> [CGPoint] {
        var mutatedPoints: [CGPoint] = [CGPoint]()
        let numPoints = 3
        switch line.type {
        case .HORIZONTAL:
            let startX = Double(line.startPoint.x)
            let endX = Double(line.endPoint.x)
            print("startx: \(startX), endX: \(endX)")
            var lastX = startX
            mutatedPoints.append(line.startPoint + centerPoint)
            for i in 0..<numPoints {
                let thisDif: Double = Double.random(in: 0..<abs(lastX - endX))
                
                var thisX: Double = 0.0
                if (endX < lastX) {
                    thisX = lastX - thisDif
                }
                else {
                    thisX = lastX + thisDif
                }
                lastX = thisX
                mutatedPoints.append(CGPoint(x: thisX, y: line.c + Double.random(in: -10...10)) + centerPoint)
            }
            mutatedPoints.append(line.endPoint + centerPoint)
            break;
        case .VERTICAL:
            let startY = Double(line.startPoint.y)
            let endY = Double(line.endPoint.y)
            var lastY = startY
            mutatedPoints.append(line.startPoint + centerPoint)
            for i in 0..<numPoints {
                let thisDif: Double = Double.random(in: 0..<abs(lastY - endY))
                
                var thisY: Double = 0.0
                if (endY < lastY) {
                    thisY = lastY - thisDif
                }
                else {
                    thisY = lastY + thisDif
                }
                lastY = thisY
                mutatedPoints.append(CGPoint(x: line.d + Double.random(in: -10...10), y: thisY) + centerPoint)
            }
            mutatedPoints.append(line.endPoint + centerPoint)
            break;
        case .GRADIENT:
            let startX = Double(line.startPoint.x)
            let endX = Double(line.endPoint.x)
            var lastX = startX
            mutatedPoints.append(line.startPoint + centerPoint + centerPoint)
            for i in 0..<numPoints {
                let thisDif: Double = Double.random(in: 0..<abs(lastX - endX))
                
                var thisX: Double = 0.0
                if (endX < lastX) {
                    thisX = lastX - thisDif
                }
                else {
                    thisX = lastX + thisDif
                }
                lastX = thisX
                mutatedPoints.append(CGPoint(x: thisX, y: line.y(thisX) + Double.random(in: -10...10)) + centerPoint)
            }
            mutatedPoints.append(line.endPoint + centerPoint)
            break;
        }
        return mutatedPoints
    }
    
    func doesCollide(waypoint: Waypoint) -> Bool {
        return doesCollideWithShape(points: points, waypoint: waypoint)
    }
}
