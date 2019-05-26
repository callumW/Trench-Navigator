//
//  Queue.swift
//  Trench Navigator
//
//  Created by Callum Wilson on 26/05/2019.
//  Copyright © 2019 Callum Wilson. All rights reserved.
//

import Foundation

class Node<Element> {
    var cur: Element?
    
    var prev: Node<Element>?
    var next: Node<Element>?
    
    init(_ obj: Element) {
        self.cur = obj
    }
    
    deinit {
        prev = nil
        next = nil
    }

}

class Queue<Element> {
    var head: Node<Element>? = nil
    var tail: Node<Element>? = nil

    init() {
        
    }
    
    deinit {
        clear()
    }
    
    func addElement(_ a: Element) {
        if head != nil {
            let node = Node<Element>(a)
            if tail != nil {    // Queue has two or more elements
                node.prev = tail
                tail!.next = node
            }
            else {  // queue has exactly one element
                node.prev = head
                head!.next = node
            }
            tail = node
        }
        else {  // queue has no elements
            head = Node<Element>(a)
        }
    }
    
    /*
        peek at head of queue
    */
    func peek() -> Element? {
        if head != nil {
            return head!.cur
        }
        else {
            return nil
        }
    }
    
    /*
        Pop head of queue
    */
    func pop() {
        if head != nil {
            if tail != nil {
                let next = head!.next
                next!.prev = nil
                if next!.next == nil {  // Element is tail
                    tail = nil
                }
                head = next
            }
            else {
                head = nil
            }
        }
    }
    
    func clear() {
        while head != nil {
            head!.prev = nil
            let tmp = head!.next
            head = tmp
        }
        tail = nil
    }
    
    /*
        Helper function to iterate over queue
    */
    func next(_ cur: Node<Element>? = nil) -> Node<Element>? {
        if cur != nil {
            if cur!.next != nil {
                return cur!.next
            }
        }
        else {
            if head != nil {
                return head
            }
        }
        return nil
    }
}
