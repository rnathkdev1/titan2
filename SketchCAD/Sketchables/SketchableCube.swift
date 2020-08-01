//
//  SketchableCube.swift
//  SketchCAD
//
//  Created by Ramnath Pillai on 4/5/20.
//  Copyright © 2020 Oxymoron. All rights reserved.
//

import Foundation
import MetalKit

// This is the Bezier curve that is seen on screen
class SketchableCube: SketchableSurface {
    var primitiveType: MTLPrimitiveType = .triangleStrip
    var sketchableVertices = [Vertex]()
    
    var cubicBezierCurve: CubicBezierCurve
    var controlPointsVisible: Bool
    var isSelected: Bool
    
    init(curve: CubicBezierCurve){
        self.cubicBezierCurve = curve
        self.controlPointsVisible = false
        self.isSelected = false
        calculateSketchableVertices()
    }
    
    private func calculateSketchableVertices() {
        let vertices = [
            SIMD4<Float>(-1.0, 1.0, 1.0, 1.0),     // Front-top-left
            SIMD4<Float>(1.0, 1.0, 1.0, 1.0),      // Front-top-right
            SIMD4<Float>(-1.0, -1.0, 1.0,  1.0),   // Front-bottom-left
            SIMD4<Float>(1.0, -1.0, 1.0, 1.0),     // Front-bottom-right
            SIMD4<Float>(1.0, -1.0, -1.0, 1.0),    // Back-bottom-right
            SIMD4<Float>(1.0, 1.0, 1.0,  1.0),     // Front-top-right
            SIMD4<Float>(1.0, 1.0, -1.0, 1.0),     // Back-top-right
            SIMD4<Float>(-1.0, 1.0, 1.0,  1.0),    // Front-top-left
            SIMD4<Float>(-1.0, 1.0, -1.0, 1.0),    // Back-top-left
            SIMD4<Float>(-1.0, -1.0, 1.0, 1.0),    // Front-bottom-left
            SIMD4<Float>(-1.0, -1.0, -1.0, 1.0),   // Back-bottom-left
            SIMD4<Float>(1.0, -1.0, -1.0,  1.0),   // Back-bottom-right
            SIMD4<Float>(-1.0, 1.0, -1.0, 1.0),    // Back-top-left
            SIMD4<Float>(1.0, 1.0, -1.0,  1.0)     // Back-top-right
        ]
        
        var verticesWithColor = [Vertex]()
        
        let thisColor = ColorIndex.worldCurve.rawValue
        // Create the vector of vertices
        for i in 0 ..< vertices.count {
            verticesWithColor.append(Vertex(position: vertices[i], colorIndex: UInt16(thisColor)))
        }
        
        self.sketchableVertices = verticesWithColor
    }
}
