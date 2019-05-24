//
//  Wall.swift
//  Trench Navigator
//
//  Created by Callum Wilson on 21/05/2019.
//  Copyright © 2019 Callum Wilson. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class Maze {
    var walls: [Wall] = [Wall]()
    var boolMap: [Bool]
    var mazeWidth: Int
    var mazeHeight: Int
    
    let scene: GameScene!
    
    init(scene: GameScene) {
        self.scene = scene
        let sceneSize = scene.size
        mazeWidth = Int(sceneSize.width) / Wall.WALL_SIDE_LENGTH
        mazeHeight = Int(sceneSize.height) / Wall.WALL_SIDE_LENGTH
        
        // walls.reserveCapacity(mazeWidth * mazeHeight)
        boolMap = Array(repeating: true, count: mazeWidth * mazeHeight)
        
        generateMapPrim()
        
        realiseMap()
    }
    
    func shouldAdd(_ point: CGPoint) -> Bool {
        var separatesOnXAxis: Bool = false
        var separatesOnYAxis: Bool = false
        if Int(point.x) - 1 >= 0 {
            if Int(point.x + 1) < mazeWidth {
                separatesOnXAxis = !boolMap[Int(point.y) * mazeWidth + Int(point.x) - 1] && !boolMap[Int(point.y) * mazeWidth + Int(point.x) + 1]
            }
        }
        if Int(point.y - 1) >= 0 {
            if Int(point.y + 1) < mazeHeight {
                separatesOnYAxis = !boolMap[Int(point.y - 1) * mazeWidth + Int(point.x)] && !boolMap[Int(point.y + 1) * mazeWidth + Int(point.x)]
            }
        }
        return !separatesOnXAxis && !separatesOnYAxis
    }
    
    func generateMapPrim() {
        let startX = 1
        let startY = 1
        
        boolMap[startX * startY] = false
        
        var wallList = [CGPoint]()
        
        wallList.append(CGPoint(x: 0, y: 1))
        wallList.append(CGPoint(x: 1, y: 0))
        wallList.append(CGPoint(x: 2, y: 1))
        wallList.append(CGPoint(x: 1, y: 2))
        
        while wallList.count > 0 {
            let wallIndex = Int.random(in: 0..<wallList.count)
            let point = wallList[wallIndex]
            
            if shouldAdd(point) {
                boolMap[Int(point.y) * mazeWidth + Int(point.x)] = false
                
                // Add neighbouring walls
                if Int(point.x - 1) >= 0 {
                    if boolMap[Int(point.y) * mazeWidth + Int(point.x) - 1] {
                        wallList.append(CGPoint(x: point.x - 1, y: point.y))
                    }
                }
                if Int(point.x + 1) < mazeWidth {
                    if boolMap[Int(point.y) * mazeWidth + Int(point.x) + 1] {
                        wallList.append(CGPoint(x: point.x + 1, y: point.y))
                    }
                }
                if Int(point.y - 1) >= 0 {
                    if boolMap[Int(point.y - 1) * mazeWidth + Int(point.x)] {
                        wallList.append(CGPoint(x: point.x, y: point.y - 1))
                    }
                }
                if Int(point.y + 1) < mazeHeight {
                    if boolMap[Int(point.y + 1) * mazeWidth + Int(point.x)] {
                        wallList.append(CGPoint(x: point.x, y: point.y + 1))
                    }
                }
            }
            wallList.remove(at: wallIndex)
        }
    }
    
    func realiseMap() {
        var wallCount = 0
        for x in 0..<mazeWidth {
            for y in 0..<mazeHeight {
                if boolMap[y * mazeWidth + x] {
                    wallCount += 1
                    walls.append(Wall(scene: scene, position: CGPoint(x: (x * Wall.WALL_SIDE_LENGTH) + Wall.WALL_SIDE_LENGTH / 2, y: (y * Wall.WALL_SIDE_LENGTH) + Wall.WALL_SIDE_LENGTH / 2)))
                }
            }
        }
        print("Wall count: " + String(wallCount))
    }
    
    func willCollide(waypoint: Waypoint) -> Bool {
        for wall in walls {
            if wall.willCollide(waypoint: waypoint) {
                return true
            }
        }
        return false
    }
}

class Wall {
    var sprite: SKShapeNode! = nil
    var scene: GameScene! = nil
    let collisionRect: CGRect
    var colSprite: SKShapeNode! = nil
    
    static let WALL_SIDE_LENGTH: Int = 20
    
    init(scene: GameScene, position: CGPoint, size: CGSize) {
        self.scene = scene
        collisionRect = CGRect(x: position.x - size.width / 2, y: position.y - size.height / 2, width: size.width, height: size.height)
        // collisionRect = CGRect(origin: position, size: size)
        sprite = SKShapeNode(rectOf: size)
        sprite.strokeColor = SKColor.green
        sprite.fillColor = SKColor.green
        sprite.position = position
        self.scene.addChild(sprite)
        
        colSprite = SKShapeNode(rect: collisionRect)
        colSprite.strokeColor = SKColor.red
        self.scene.addChild(colSprite)
        
    }
    
    convenience init(scene: GameScene, position: CGPoint) {
        self.init(scene: scene, position: position, size: CGSize(width: Wall.WALL_SIDE_LENGTH, height: Wall.WALL_SIDE_LENGTH))
    }
    
    deinit {
        if sprite.parent != nil {
            sprite.removeFromParent()
        }
        if colSprite.parent != nil {
            colSprite.removeFromParent()
        }
    }
    
    func willCollide(waypoint: Waypoint) -> Bool {
        let line = waypoint.toLine()
        return line.doesIntersect(rect: self.collisionRect)
    }
    
}
