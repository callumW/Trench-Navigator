//
//  MutatingShape.swift
//  Trench Navigator
//
//  Created by Callum Wilson on 28/05/2019.
//  Copyright © 2019 Callum Wilson. All rights reserved.
//

import Foundation
import CoreGraphics

class MutatingShape: PolyShape {
    var points: [CGPoint]
    
    init(originPoint: CGPoint) {
        // start with triangle shape, counter clockwise
        points = [
            CGPoint(x: -40, y: -40),
            CGPoint(x: 40, y: -40),
            CGPoint(x: 0, y: 40),
            CGPoint(x: -40, y: -40)
        ]
        
        // pick a random line
        let numRuns = Int.random(in: 1...100)
        
        for index in 0..<numRuns {
            var lineNum = Int.random(in: 1..<points.count)
            let line = Line(a: points[lineNum - 1], b: points[lineNum])
            
            // pick a random point away from line
            
            switch line.type {
            case .GRADIENT:
                if line.endPoint.x > line.startPoint.x {
                    /*
                        Note: We should really increase the y value perpendicular to the line, rather than to the x axis
                    */
                    // chose point below
                    let newX = Double.random(in: Double(line.startPoint.x)...Double(line.endPoint.x))
                    let newY = line.y(newX) - 10
                    points.insert(CGPoint(x: newX, y: newY), at: lineNum)
                }
                else {
                    // chose point above
                    let newX = Double.random(in: Double(line.endPoint.x)...Double(line.startPoint.x))
                    let newY = line.y(newX) + 10
                    points.insert(CGPoint(x: newX, y: newY), at: lineNum)
                }
            case .HORIZONTAL:
                if line.endPoint.x > line.startPoint.x {
                    // chose point below
                    let newX = Double.random(in: Double(line.startPoint.x)...Double(line.endPoint.x))
                    let newY = line.c - 10
                    points.insert(CGPoint(x: newX, y: newY), at: lineNum)
                }
                else {
                    // chose point above
                    let newX = Double.random(in: Double(line.endPoint.x)...Double(line.startPoint.x))
                    let newY = line.c + 10
                    points.insert(CGPoint(x: newX, y: newY), at: lineNum)
                }
            case .VERTICAL:
                if line.endPoint.y > line.startPoint.y {
                    // choose point to left
                    let newY = Double.random(in: Double(line.startPoint.y)...Double(line.endPoint.y))
                    let newX = line.d - 10
                    points.insert(CGPoint(x: newX, y: newY), at: lineNum)
                }
                else {
                    // chose point to right
                    let newY = Double.random(in: Double(line.endPoint.y)...Double(line.startPoint.y))
                    let newX = line.d + 10
                    points.insert(CGPoint(x: newX, y: newY), at: lineNum)
                }
            }
        }
        
        for index in 0..<points.count {
            points[index] = points[index] + originPoint
        }
        
    }
    
    func doesCollide(waypoint: Waypoint) -> Bool {
        return doesCollideWithShape(points: points, waypoint: waypoint)
    }
    
    
}
