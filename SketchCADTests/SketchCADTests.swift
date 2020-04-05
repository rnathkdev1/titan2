//
//  SketchCADTests.swift
//  SketchCADTests
//
//  Created by Ramnath Pillai on 8/22/19.
//  Copyright © 2019 Oxymoron. All rights reserved.
//

import XCTest
@testable import SketchCAD

class CubicBezierCurveTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testStraightLine() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let p0 = SIMD3<Float>(1.0, 1.0, 1.0)
        let p1 = SIMD3<Float>(2.0, 1.0, 1.0)
        let p2 = SIMD3<Float>(3.0, 1.0, 1.0)
        let p3 = SIMD3<Float>(4.0, 1.0, 1.0)
        
        let c = CubicBezierCurve(P0: p0, P1: p1, P2: p2, P3: p3)
        let d = CubicBezierCurve(points: [p0, p1, p2, p3]);
        
        for i in 0..<4 {
            XCTAssertTrue(c.controlVector[i].nearlyEqual(d.controlVector[i]), "Control Vector P\(i) are not equal: \(d.controlVector[i])")
        }
    }
    
    func testReconstructingPoints() {
        let p0 = SIMD3<Float>(1.0, 2.0, 2.0)
        let p1 = SIMD3<Float>(2.0, 3.0, 3.0)
        let p2 = SIMD3<Float>(3.0, 4.0, 4.0)
        let p3 = SIMD3<Float>(4.0, 5.0, 5.0)
        
        let refCurve = CubicBezierCurve(P0: p0, P1: p1, P2: p2, P3: p3)
        
        let samplePoints = refCurve.getInterpolatedPoints(sampleCount: 1000);
        
        let reconstructedCurve = CubicBezierCurve(points: samplePoints)
        
        for i in 0..<4 {
        XCTAssertTrue(refCurve.controlVector[i].nearlyEqual(reconstructedCurve.controlVector[i]), "Control Vector P\(i) are not equal: \(reconstructedCurve.controlVector[i])")
        }
    }
    /*
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }*/

}

public extension SIMD3 where Scalar == Float {
    func round()->SIMD3<Float> {
        let roundTo = Float(100000.0);
        let round_x = roundf(roundTo * self.x) / roundTo;
        let round_y = roundf(roundTo * self.y) / roundTo;
        let round_z = roundf(roundTo * self.z) / roundTo;
        
        return SIMD3<Float>(round_x, round_y, round_z)
    }
    
    func nearlyEqual(_ other: SIMD3<Float>) -> Bool {
        return self.round() == other.round()
    }
}
