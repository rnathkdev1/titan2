//
//  DrawableView.swift
//  SketchCAD
//
//  Created by Ramnath Pillai on 8/26/19.
//  Copyright © 2019 Oxymoron. All rights reserved.
//

import UIKit
import MetalKit

class DrawableView: MTKView {
    
    // var world: Sketchable
    var screenCurves = [Sketchable]()
    var worldCurves = [Sketchable]()
    
    convenience init() {
        self.init()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addObject3D(curve: Sketchable) {
        
        worldCurves.append(curve);
        
        guard let renderer = self.delegate as? Renderer else {
            //FIXME: Add an error message
            print("Delegate is not Renderer")
            return;
        }
        
        renderer.addObject3D(curve: curve)
    }
    
    func addScreenCurve() {
        let vertices = [
            SIMD4<Float>(-1, -1, 0, 1),
            SIMD4<Float>(1, -1, 0, 1),
            SIMD4<Float>(0,  0, 0, 1),
        ]
        
        var indexedVertices = [Vertex]()
        for i in 0..<vertices.count {
            let thisVertex = Vertex(position: vertices[i],
                                    colorIndex: UInt16(ColorIndex.screenCurve.rawValue))
            indexedVertices.append(thisVertex)
        }
        
        guard let renderer = self.delegate as? Renderer else {
            //FIXME: Add an error message
            print("Delegate is not Renderer")
            return;
        }
        
        renderer.addVertices2D(vertices: indexedVertices)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}
