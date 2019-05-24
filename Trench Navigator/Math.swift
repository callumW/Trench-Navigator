//
//  Math.swift
//  Trench Navigator
//
//  Created by Callum Wilson on 21/05/2019.
//  Copyright © 2019 Callum Wilson. All rights reserved.
//

import Foundation
import CoreGraphics

enum LineType {
    case VERTICAL
    case HORIZONTAL
    case GRADIENT
}

/*
    Object defining line in form y = mx + c
*/
class Line {
    let m: Double
    let c: Double   // y - axis intercept
    let d: Double   // x - axis intercept
    let type: LineType
    let minX: Double
    let maxX: Double
    let minY: Double
    let maxY: Double
    
    init(a: CGPoint, b: CGPoint) {
        // TODO how to meaningfuly check whether line is horizontal / vertical
        if a.x == b.x { // horizontal line
            type = LineType.HORIZONTAL
            c = Double(a.x)
            m = 0.0
            d = Double.infinity
        }
        else if a.y == b.y { // vertical line
            type = LineType.VERTICAL
            c = Double.infinity
            m = Double.infinity
            d = Double(a.y)
        }
        else {
            type = LineType.GRADIENT
            m = Double(a.y - b.y) / Double(a.x - b.x)
            c = Double(a.y) - m * Double(a.x)
            d = (0.0 - c) / m
        }
        
        if a.x < b.x {
            minX = Double(a.x)
            maxX = Double(b.x)
        }
        else {
            minX = Double(b.x)
            maxX = Double(a.x)
        }
        
        if a.y < b.y {
            minY = Double(a.y)
            maxY = Double(b.y)
        }
        else {
            minY = Double(b.y)
            maxY = Double(a.y)
        }
    }
    
    func doesIntersect(line: Line) -> Bool {
        return false
    }
    
    func doesIntersect(rect: CGRect) -> Bool {
        
        // lets first get lines to define our faces
        switch self.type {
        case .GRADIENT:
            let left = CGPoint(x: Double(rect.minX), y: y(Double(rect.minX)))
            let right = CGPoint(x: Double(rect.maxX) - 1, y: y(Double(rect.maxX)))  // CGRect::contains does not consider right line to be in the rect
            let bottom = CGPoint(x: x(Double(rect.minY)), y: Double(rect.minY))
            let top = CGPoint(x: x(Double(rect.maxY)), y: Double(rect.maxY) - 1)    // CGRect::contains does not consider top line to be in the rect
            
            // print("top: " + NSCoder.string(for: top) + " | bottom: " + NSCoder.string(for: bottom) + " | left: " + NSCoder.string(for: left) + " | right: " + NSCoder.string(for: right))
            
            // print("Collision Rect: " + NSCoder.string(for: rect))
            
            var willCollide: Bool = false
            
            if (inDomain(left)) {
                willCollide = willCollide || rect.contains(left)
            }
            
            if (inDomain(right)) {
                willCollide = willCollide || rect.contains(right)
            }
            
            if (inDomain(top)) {
                willCollide = willCollide || rect.contains(top)
            }
            
            if (inDomain(bottom)) {
                willCollide = willCollide || rect.contains(bottom)
            }
            
            return willCollide
        case .HORIZONTAL:
            return self.d <= Double(rect.maxX) && self.d >= Double(rect.minX)
        case .VERTICAL:
            return self.c <= Double(rect.maxY) && self.c >= Double(rect.minY)
        }
    }
    
    private func inDomain(_ point: CGPoint) -> Bool {
        let isInX: Bool = minX <= Double(point.x) && maxX >= Double(point.x)
        let isInY: Bool = minY <= Double(point.y) && maxY >= Double(point.y)
        return isInY && isInX
    }
    
    private func y(_ x: Double) -> Double {
        return m * x + c
    }
    
    private func x(_ y: Double) -> Double {
        return (y - c) / m
    }
}
