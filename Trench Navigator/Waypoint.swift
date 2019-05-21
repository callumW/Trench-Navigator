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

func distance(_ a: CGPoint,_ b: CGPoint) -> CGFloat {
    return sqrt(pow(a.x - b.x, 2) + pow(a.y - b.y, 2))
}


class Waypoint {
    var endCircle: SKShapeNode = SKShapeNode(circleOfRadius: 3)
    
    var path: CGMutablePath = CGMutablePath()
    var line: SKShapeNode = SKShapeNode()
    var scene: GameScene!
    
    let SUBMARINE_SPEED: CGFloat = 200    // submarine moves 200 pixels per second
    
    init(endPoint: CGPoint, startPoint: CGPoint, scene: GameScene) {
        self.endCircle.position = endPoint
        self.endCircle.fillColor = SKColor.green
        self.endCircle.strokeColor = SKColor.green
        self.scene = scene
        
        self.path.move(to: startPoint)
        self.path.addLine(to: endPoint)
        
        self.line.path = self.path
        self.line.strokeColor = SKColor.green
        self.line.lineWidth = 1

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
    
    func startMove(player: SKSpriteNode, complete: @escaping () -> Void) {
        // workout orientation for player
        let point = endCircle.position
        let adjacent = player.position.x - point.x
        let oposite = player.position.y - point.y
        
        let angle = atan2(oposite, adjacent) + 90 * (CGFloat.pi / 180)
        
        let rotateAction = SKAction.rotate(toAngle: angle, duration: 0.3, shortestUnitArc: true)    // let swift choose the direction to rotate
        
        /*
            Calculate the time it will take to move the distance required
        */
        let totalDistance = distance(player.position, point)
        
        let timeToTravel = totalDistance / SUBMARINE_SPEED
        
        let moveAction = SKAction.move(to: point, duration: Double(timeToTravel))
                
        
        player.run(SKAction.sequence([rotateAction, moveAction]), completion: complete)
    }
}

class WaypointNode {
    init(_ p: Waypoint) {
        self.waypoint = p
    }
    var waypoint: Waypoint
    var next: WaypointNode? = nil
}

class WaypointPath {
    
    var scene: GameScene!
    var waypoints: WaypointNode! = nil
    var player: SKSpriteNode!
    
    init(_ scene: GameScene, player: SKSpriteNode) {
        self.scene = scene
        self.player = player
    }
    
    
    func addWaypoint(point: CGPoint) {
        if waypoints != nil {
            var tmp = waypoints
            while (tmp!.next != nil) {
                tmp = tmp!.next
            }
            tmp!.next = WaypointNode(Waypoint(endPoint: point, startPoint: tmp!.waypoint.endCircle.position, scene: self.scene))
        }
        else {
            waypoints = WaypointNode(Waypoint(endPoint: point, startPoint: self.player.position, scene: self.scene))
            waypoints!.waypoint.startMove(player: player, complete: self.removeHeadWaypoint)
        }

    }
    
    func updateLineLength() {
        if waypoints != nil {
            let waypoint = waypoints!.waypoint
            waypoint.updateLine(self.player.position)
        }
    }
    
    func removeHeadWaypoint() {
        if waypoints != nil {
            waypoints = waypoints!.next
            if waypoints != nil {
                waypoints!.waypoint.startMove(player: player, complete: self.removeHeadWaypoint)
            }
        }
    }
}
