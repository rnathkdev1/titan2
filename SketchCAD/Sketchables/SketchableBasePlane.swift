//
//  SketchableBasePlane.swift
//  SketchCAD
//
//  Created by Ramnath Pillai on 9/3/19.
//  Copyright © 2019 Oxymoron. All rights reserved.
//

import Foundation
import MetalKit

// Playground sits at z = 0
// Center of the playground is at Origin

class SketchableBasePlane: Sketchable {
    var primitiveType: MTLPrimitiveType = .triangleStrip
    var sketchableVertices = [Vertex]()
    let side: Float = 10.0
    
    
    init() {
        let left = -side/2.0
        let right = side/2.0
        let top = side/2.0
        let bottom = -side/2.0
        
        // Base plate
        let vertices = [
            SIMD4<Float>(bottom, left, 0, 1),
            SIMD4<Float>(bottom, right, 0, 1),
            SIMD4<Float>(top, left, 0, 1),
            SIMD4<Float>(top, right, 0, 1)
        ]

        // Generate vertices
        for vertex in vertices {
            sketchableVertices.append(Vertex(position: vertex, colorIndex: UInt16(ColorIndex.basePlane.rawValue)))
        }
    }
}
