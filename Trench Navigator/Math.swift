//
//  Math.swift
//  Trench Navigator
//
//  Created by Callum Wilson on 21/05/2019.
//  Copyright © 2019 Callum Wilson. All rights reserved.
//

import Foundation
import CoreGraphics

/*
    Object defining line in form y = mx + c
*/
class Line {
    let m: Double
    let c: Double
    
    init(a: CGPoint, b: CGPoint) {
        m = Double(a.y - b.y) / Double(a.x - b.x)
        c = Double(a.y) - m * Double(a.x)
    }
    
    /*
        Recall, to find point of intersection of two lines:
     
    */
    func intersectionPoint(line: Line) -> CGPoint? {
        
        let deltaC = line.c - self.c
        
        let deltaM = self.m - line.m
        
        if deltaM == 0.0 {
            
        }
        

        let x = (line.c - self.c) / (self.m - line.m)
        
        // now we can workout y
        let y = self.getY(x)
        
        return CGPoint(x: x, y: y)
    }
    
    func getY(_ x: Double) -> Double {
        return self.m * x + self.c
    }
}
