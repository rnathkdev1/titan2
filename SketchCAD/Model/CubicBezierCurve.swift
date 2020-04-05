//
//  CubicBezierCurve.swift
//  SketchCAD
//
//  Created by Ramnath Pillai on 8/17/19.
//  Copyright © 2019 Oxymoron. All rights reserved.
//

import Foundation

class CubicBezierCurve {
    private(set) var controlVector = [SIMD3<Float>]()
    
    init(P0: SIMD3<Float>, P1: SIMD3<Float>, P2: SIMD3<Float>, P3: SIMD3<Float>) {
        self.controlVector = [P0, P1, P2, P3];
    }
    
    init(points: [SIMD3<Float>]) {
        // Get the number of points
        let n = points.count
        
        let p0 = points[0]
        let p3 = points[n-1]
        
        var p1: SIMD3<Float>
        var p2: SIMD3<Float>
        
        switch n {
        case 1:
            p1 = p0
            p2 = p0
        case 2:
            p1 = p0
            p2 = p3
        case 3:
            p1 = points[1]
            p2 = points[1]
        default:
            // Generate n points between 0 and 1
            let step = 1.0/(Double(n)-1.0);
            
            var a1 = 0.0, a2 = 0.0, a12 = 0.0, c1 = SIMD3<Float>(repeating: 0.0), c2 = SIMD3<Float>(repeating: 0.0)
            var i = 0;
            for t in stride(from: 0.0, through: 1.0, by: step) {
                let b0 = pow(1.0-t, 3)
                let b1 = ( 3.0 * t * pow(1.0-t,2))
                let b2 = (3.0*pow(t,2)*(1.0-t))
                let b3 = pow(t, 3)
                
                a1 += pow(b1,2)
                a2 += pow(b2,2)
                a12 += b1 * b2
                
                let bpdiff = (b0 * p0) + (b3 * p3)
                let pdiff = points[i] - bpdiff
                
                c1 += b1 * pdiff
                c2 += b2 * pdiff
                
                i+=1
            }
            let den = a1*a2 - a12*a12
            
            if den == 0 {
                p1 = p0
                p2 = p3
            } else {
                p1=(a2*c1 - a12*c2) / den
                p2=(a1*c2 - a12*c1) / den
            }
        }
        
        // Now generate the control vectors
        self.controlVector = [p0, p1, p2, p3]
    }

    func getInterpolatedPoints(sampleCount n: Int) -> [SIMD3<Float>] {
        
        assert(n >= 2)
        
        var interpolatedPoints = [SIMD3<Float>]()
        let step = 1.0/(Double(n)-1.0)
        
        let P0 = controlVector[0]
        let P1 = controlVector[1]
        let P2 = controlVector[2]
        let P3 = controlVector[3]

        for t in stride(from: 0.0, through: 1.0, by: step) {
            let a = (1.0 - t) * (1.0 - t) * (1.0 - t)
            let b = 3 * (t) * (1.0 - t) * (1.0 - t)
            let c = 3 * t * t * (1.0 - t)
            let d = t * t * t
            
            var thisPoint = a * P0
            thisPoint += b * P1
            thisPoint += c * P2
            thisPoint += d * P3
            
            interpolatedPoints.append(thisPoint)
        }
        
        return interpolatedPoints
    }
}
