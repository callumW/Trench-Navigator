//
//  Waypoint.swift
//  Trench Navigator
//
//  Created by Callum Wilson on 18/05/2019.
//  Copyright © 2019 Callum Wilson. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit


class Waypoint {
    var endCircle: SKShapeNode = SKShapeNode(circleOfRadius: 10)
    
    var path: CGMutablePath = CGMutablePath()
    var line: SKShapeNode = SKShapeNode()
    var scene: GameScene!
    
    init(endPoint: CGPoint, startPoint: CGPoint, scene: GameScene) {
        self.endCircle.position = endPoint
        self.endCircle.fillColor = SKColor.green
        self.endCircle.strokeColor = SKColor.green
        self.scene = scene
        
        self.path.move(to: startPoint)
        self.path.addLine(to: endPoint)
        
        self.line.path = self.path
        self.line.strokeColor = SKColor.green
        self.line.lineWidth = 2

        scene.addChild(self.endCircle)
        scene.addChild(self.line)
    }
    
    deinit {
        remove()
    }
    
    func remove() {
        if endCircle.parent != nil {
            endCircle.removeFromParent()
        }
        
        if self.line.parent != nil {
            self.line.removeFromParent()
        }
    }
    
    func updateLine(_ newStartPoint: CGPoint) {
        self.path = CGMutablePath()
        self.path.move(to: self.endCircle.position)
        self.path.addLine(to: newStartPoint)
        self.line.path = self.path
    }
}

class WaypointNode {
    init(_ p: Waypoint) {
        self.waypoint = p
    }
    var waypoint: Waypoint
    var next: WaypointNode? = nil
    weak var prev: WaypointNode? = nil
}

class WaypointList {
    
    var head: WaypointNode? = nil
    var tail: WaypointNode? = nil
    
    func popHead() {
        if head != nil {
            if let tmp = head!.next {
                head = tmp
                tmp.prev = nil
            }
            else {
                head = nil
            }
            
        }
    }
    
    func current() -> WaypointNode? {
        return head
    }
    
    func add(_ p: Waypoint) {
        let newTail = WaypointNode(p)
        if tail == nil {
            if head == nil {
                head = newTail
            }
            else {
                head!.next = newTail
                tail = newTail
                tail!.prev = head
                tail!.waypoint.updateLine(head!.waypoint.endCircle.position)
            }
        }
        else {
            tail!.next = newTail
            newTail.prev = tail
            tail = newTail
            newTail.waypoint.updateLine(newTail.prev!.waypoint.endCircle.position)
        }
    }
}
