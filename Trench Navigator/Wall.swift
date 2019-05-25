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

enum MazeElementState {
    case WALL
    case UNVISITED
    case PASSAGE
}

class Maze {
    var walls: [Wall] = [Wall]()
    var boolMap: [MazeElementState]
    var mazeWidth: Int
    var mazeHeight: Int
    var border: SKShapeNode
    var borderRect: CGRect
    
    let scene: GameScene!
    
    init(scene: GameScene) {
        self.scene = scene
        let sceneSize = scene.size
        
        let mazeArea = CGRect(x: 0.15 * sceneSize.width, y: 0, width: 0.7 * sceneSize.width, height: sceneSize.height)
        mazeWidth = Int(mazeArea.width) / Wall.WALL_SIDE_LENGTH
        mazeHeight = Int(mazeArea.height) / Wall.WALL_SIDE_LENGTH
        
        let width = Double(mazeWidth * Wall.WALL_SIDE_LENGTH)
        let height = Double(mazeHeight * Wall.WALL_SIDE_LENGTH)
        let xOffset = (Double(scene.size.width) - width) / 2.0
        let yOffset = (Double(scene.size.height) - height) / 2.0
        
        borderRect = CGRect(origin: CGPoint(x: xOffset, y: yOffset), size: CGSize(width: width, height: height))
        

        border = SKShapeNode(rect: borderRect)
        border.strokeColor = SKColor.blue
        scene.addChild(border)
        
        // walls.reserveCapacity(mazeWidth * mazeHeight)
        boolMap = Array(repeating: MazeElementState.UNVISITED, count: mazeWidth * mazeHeight)
        
        generateMapPrim()
        
        realiseMap()
    }
    
    deinit {
        if border.parent != nil {
            border.removeFromParent()
        }
    }
    
    func getStartPoint() -> CGPoint {
        return CGPoint(x: borderRect.minX, y: borderRect.minY)
    }
    
    // TODO remove casts
    func shouldAdd(_ point: CGPoint) -> Bool {
        var numNeighbours: Int = 0
        if Int(point.x) - 1 >= 0 {
            if boolMap[Int(point.y) * mazeWidth + Int(point.x) - 1] != MazeElementState.UNVISITED {
                print("neighbour to left")
                numNeighbours += 1
            }
        }
        if Int(point.x + 1) < mazeWidth {
            if boolMap[Int(point.y) * mazeWidth + Int(point.x) + 1] != MazeElementState.UNVISITED {
                print("neighbour to right")
                numNeighbours += 1
            }
        }
        if Int(point.y - 1) >= 0 {
            if boolMap[Int(point.y - 1) * mazeWidth + Int(point.x)] != MazeElementState.UNVISITED {
                print("neighbour below")
                numNeighbours += 1
            }
            if Int(point.y + 1) < mazeHeight {
                if boolMap[Int(point.y + 1) * mazeWidth + Int(point.x)] != MazeElementState.UNVISITED {
                    print("neightbour above")
                    numNeighbours += 1
                }
            }
        }
        return numNeighbours == 1
    }
    
    func generateMapPrim() {
        let startX = 0
        let startY = 0
        
        boolMap[startY * mazeWidth + startX] = MazeElementState.PASSAGE
        
        var wallList = [CGPoint]()
        
        wallList.append(CGPoint(x: 0, y: 1))
        wallList.append(CGPoint(x: 1, y: 0))
//        wallList.append(CGPoint(x: 2, y: 1))
//        wallList.append(CGPoint(x: 1, y: 2))
        
        while wallList.count > 0 {
            let wallIndex = Int.random(in: 0..<wallList.count)
            let point = wallList[wallIndex]
            print("evaluating wall at: \(wallIndex): " + NSCoder.string(for: point))
            
            
            if shouldAdd(point) {
                boolMap[Int(point.y) * mazeWidth + Int(point.x)] = MazeElementState.PASSAGE
                
                // Add neighbouring walls
                if Int(point.x - 1) >= 0 {
                    if boolMap[Int(point.y) * mazeWidth + Int(point.x) - 1] != MazeElementState.PASSAGE {
                        wallList.append(CGPoint(x: point.x - 1, y: point.y))
                    }
                }
                if Int(point.x + 1) < mazeWidth {
                    if boolMap[Int(point.y) * mazeWidth + Int(point.x) + 1] != MazeElementState.PASSAGE {
                        wallList.append(CGPoint(x: point.x + 1, y: point.y))
                    }
                }
                if Int(point.y - 1) >= 0 {
                    if boolMap[Int(point.y - 1) * mazeWidth + Int(point.x)] != MazeElementState.PASSAGE {
                        wallList.append(CGPoint(x: point.x, y: point.y - 1))
                    }
                }
                if Int(point.y + 1) < mazeHeight {
                    if boolMap[Int(point.y + 1) * mazeWidth + Int(point.x)] != MazeElementState.PASSAGE {
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
                if boolMap[y * mazeWidth + x] != MazeElementState.PASSAGE {
                    wallCount += 1
                    walls.append(Wall(scene: scene, position: CGPoint(x: CGFloat((x * Wall.WALL_SIDE_LENGTH) + Wall.WALL_SIDE_LENGTH / 2) + borderRect.minX, y: CGFloat((y * Wall.WALL_SIDE_LENGTH) + Wall.WALL_SIDE_LENGTH / 2) + borderRect.minY)))
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
    
    static let WALL_SIDE_LENGTH: Int = 25
    
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
