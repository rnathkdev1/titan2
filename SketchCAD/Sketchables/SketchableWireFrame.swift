//
//  SketchableWireFrame.swift
//  SketchCAD
//
//  Created by Ramnath Pillai on 9/3/19.
//  Copyright © 2019 Oxymoron. All rights reserved.
//

import Foundation
import MetalKit

class SketchableWireFrame: SketchableSurface {
    var primitiveType: MTLPrimitiveType = .line
    
    var sketchableVertices = [Vertex]()
    let side: Float = 10.0
    
    init() {
        let left = -side/2.0
        let right = side/2.0
        let top = side/2.0
        let bottom = -side/2.0
        
        var vertices = [SIMD4<Float>]()
        // Base plate
        for x in stride(from: left, through: right, by: 1.0) {
            vertices.append(SIMD4<Float>(bottom, x, 0, 1));
            vertices.append(SIMD4<Float>(top, x, 0, 1));
            
            vertices.append(SIMD4<Float>(x, bottom, 0, 1))
            vertices.append(SIMD4<Float>(x, top, 0, 1))
        }
        // Generate vertices
        for vertex in vertices {
            sketchableVertices.append(Vertex(position: vertex, colorIndex: UInt16(ColorIndex.baseWireFrame.rawValue)))
        }
    }
}
