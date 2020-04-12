//
//  BezierCurveView.swift
//  SketchCAD
//
//  Created by Ramnath Pillai on 8/26/19.
//  Copyright © 2019 Oxymoron. All rights reserved.
//

import Foundation
import MetalKit

// This is the Bezier curve that is seen on screen
class SketchableBezierCurve {
    var primitiveType: MTLPrimitiveType = .triangleStrip
    var sketchableVertices = [LineVertex]()
    
    var cubicBezierCurve: CubicBezierCurve
    var controlPointsVisible: Bool
    var isSelected: Bool
    
    let sampleCount = 50;
    
    init(curve: CubicBezierCurve){
        self.cubicBezierCurve = curve
        self.controlPointsVisible = false
        self.isSelected = false
        calculateSketchableVertices()
    }
    
    private func calculateSketchableVertices() {
        let points = cubicBezierCurve.getInterpolatedPoints(sampleCount: sampleCount)
        
        self.sketchableVertices = preparePointsForRendering(points: points)
        //self.sketchableVertices
    }
    
    private func preparePointsForRendering(points: [SIMD3<Float>])->[LineVertex] {
        var indexedVertices = [LineVertex]()
        // Repeat each point
        for i in 0..<points.count {
            let thisPoint = SIMD4<Float>(points[i], 1)
            var nextVertex = SIMD4<Float>(-1, -1, -1, -1)
            var prevVertex = SIMD4<Float>(-1, -1, -1, -1)
            
            if i+1 < points.count {
                nextVertex = SIMD4<Float>(points [i+1], 1)
            }
            
            if i-1 >= 0 {
                prevVertex = SIMD4<Float>(points[i-1], 1)
            }
            
            let thisVertex = LineVertex(thisVertex: thisPoint, nextVertex: nextVertex, prevVertex: prevVertex, thickness: 0.5, colorIndex: UInt16(ColorIndex.screenCurve.rawValue));
            let repeatVertex = LineVertex(thisVertex: thisPoint, nextVertex: nextVertex, prevVertex: prevVertex, thickness: -0.5, colorIndex: UInt16(ColorIndex.screenCurve.rawValue));
            indexedVertices.append(thisVertex);
            indexedVertices.append(repeatVertex);
        }
        
        return indexedVertices
    }
}
