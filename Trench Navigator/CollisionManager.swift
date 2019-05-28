//
//  CollisionManager.swift
//  Trench Navigator
//
//  Created by Callum Wilson on 26/05/2019.
//  Copyright © 2019 Callum Wilson. All rights reserved.
//

import Foundation

protocol Hittable {
    func doesCollide(waypoint: Waypoint) -> Bool
}

class CollisionManager {
    let scene: GameScene
    
    var hittables: Queue<Hittable> = Queue<Hittable>()
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    func addObject(obj: Hittable) {
        hittables.addElement(obj)
    }
    
    func doesCollide(waypoint: Waypoint) -> Bool {
        var obj = hittables.next()
        while obj != nil {
            if obj!.cur!.doesCollide(waypoint: waypoint) {
                return true
            }
            obj = hittables.next(obj)
        }
        return false
    }
}

