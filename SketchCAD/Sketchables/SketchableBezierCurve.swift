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
class SketchableBezierCurve: Sketchable {
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
            float4(-1.0, 1.0, 1.0, 1.0),     // Front-top-left
            float4(1.0, 1.0, 1.0, 1.0),      // Front-top-right
            float4(-1.0, -1.0, 1.0,  1.0),   // Front-bottom-left
            float4(1.0, -1.0, 1.0, 1.0),     // Front-bottom-right
            float4(1.0, -1.0, -1.0, 1.0),    // Back-bottom-right
            float4(1.0, 1.0, 1.0,  1.0),     // Front-top-right
            float4(1.0, 1.0, -1.0, 1.0),     // Back-top-right
            float4(-1.0, 1.0, 1.0,  1.0),    // Front-top-left
            float4(-1.0, 1.0, -1.0, 1.0),    // Back-top-left
            float4(-1.0, -1.0, 1.0, 1.0),    // Front-bottom-left
            float4(-1.0, -1.0, -1.0, 1.0),   // Back-bottom-left
            float4(1.0, -1.0, -1.0,  1.0),   // Back-bottom-right
            float4(-1.0, 1.0, -1.0, 1.0),    // Back-top-left
            float4(1.0, 1.0, -1.0,  1.0)     // Back-top-right
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
