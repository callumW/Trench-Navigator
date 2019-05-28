//
//  CollisionTests.swift
//  CollisionTests
//
//  Created by Callum Wilson on 26/05/2019.
//  Copyright © 2019 Callum Wilson. All rights reserved.
//

import XCTest


class CollisionTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testHorizontalVerticalCollide() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let horizontalLine = Line(a: CGPoint(x: 0.0, y: 0.0), b: CGPoint(x: 0.0, y: 80.0))
        let verticalLine = Line(a: CGPoint(x: -10.0, y: 40.0), b: CGPoint(x: 10.0, y: 40.0))
        
        //print("Horizontal line: " + horizontalLine.toString())
        //print("Vertical line: " + verticalLine.toString())
        
        XCTAssert(horizontalLine.doesIntersect(line: verticalLine))
        XCTAssert(verticalLine.doesIntersect(line: horizontalLine))
        XCTAssert(verticalLine.doesIntersect(line: verticalLine))
        XCTAssert(horizontalLine.doesIntersect(line: horizontalLine))
    }
    
    func testGradientVGradientCollision() {
        let line1 = Line(a: CGPoint(x: 0.0, y: 0.0), b: CGPoint(x: 10.0, y: 10.0))
        let line2 = Line(a: CGPoint(x: 10.0, y: 0.0), b: CGPoint(x: 0.0, y: 10.0))
        
        XCTAssert(line1.doesIntersect(line: line2))
        XCTAssert(line2.doesIntersect(line: line1))
    }
    
    func testNoCollision() {
        let gradientLine = Line(a: CGPoint.zero, b: CGPoint(x: 0.0, y: 30.0))
        let horizontalLine = Line(a: CGPoint(x: 30.0, y: 15.0), b: CGPoint(x: 40.0, y: 15.0))
        
        XCTAssert(!gradientLine.doesIntersect(line: horizontalLine))
    }

//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
