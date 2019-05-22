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
    
    /*
        Recall, to find point of intersection of two lines:
     
    */
    func intersectionPoint(line: Line) -> CGPoint? {
        
        switch (self.type) {
        case .GRADIENT:
            let deltaC = line.c - self.c
            let deltaM = self.m - line.m
            
            let x = deltaC / deltaM
            let y = self.getY(x) 
            break;
        case .HORIZONTAL:
            
            break;
        case .VERTICAL:
            break;
        }
        
        // now we can workout y
        
        
        if y.isInfinite {
            return nil
        }
        
        return CGPoint(x: x, y: y)
    }
    
    func getY(_ x: Double) -> Double {
        return self.m * x + self.c
    }
}
