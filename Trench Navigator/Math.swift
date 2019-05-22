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
    }
    
    func doesIntersect(line: Line) -> Bool {
        return false
    }
    
    func doesIntersect(rect: CGRect) -> Bool {
        
        // lets first get lines to define our faces
        let topLeft = CGPoint(x: rect.minX, y: rect.maxY)
        let topRight = CGPoint(x: rect.maxX, y: rect.maxY)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.minY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.minY)

        let topLine = Line(a: topLeft, b: topRight)
        let leftLine = Line(a: topLeft, b: bottomLeft)
        let bottomLine = Line(a: bottomLeft, b: bottomRight)
        let rightLine = Line(a: topRight, b: bottomRight)

        return doesIntersect(line: topLine) || doesIntersect(line: leftLine) || doesIntersect(line: bottomLine) || doesIntersect(line: rightLine)
    }
}
