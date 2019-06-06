//
//  Math.swift
//  Trench Navigator
//
//  Created by Callum Wilson on 04/06/2019.
//  Copyright © 2019 Callum Wilson. All rights reserved.
//

import Foundation
import CoreGraphics



/*
    CGPoint functions
 */
func distance(_ a: CGPoint,_ b: CGPoint) -> CGFloat {
    return sqrt(pow(a.x - b.x, 2) + pow(a.y - b.y, 2))
}

func /(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x / right.x, y: left.y / right.y)
}

func /(left: CGPoint, right: Double) -> CGPoint {
    return CGPoint(x: Double(left.x) / right, y: Double(left.y) / right)
}

func *(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x * right.x, y: left.y * right.y)
}

func *(left: CGPoint, right: Double) -> CGPoint {
    return CGPoint(x: Double(left.x) * right, y: Double(left.y) * right)
}

func -(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}
