//
//  DrawableView.swift
//  SketchCAD
//
//  Created by Ramnath Pillai on 8/26/19.
//  Copyright © 2019 Oxymoron. All rights reserved.
//

import UIKit
import MetalKit

/**
 Formats data and passes it to the Renderer.
 */
class DrawableView: MTKView {
    /**
        This is the wire mesh and the coordinate axes/planes
     */
    private var playground = [Sketchable]()
    /**
     These are the 3D curves in the world
     */
    private var worldCurves = [Sketchable]()
    
    // MARK: Initializers
    convenience init() {
        self.init()
        
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: Add sketchable playground
    func addPlaygroundObject(curve: Sketchable) {
        self.playground.append(curve);
        
        guard let renderer = self.delegate as? Renderer else {
            print("Delegate of this view is not of type Renderer")
            return;
        }
        
        // Add this object to the renderer.
        renderer.addObject3D(curve: curve)
    }
    
    /*
    func addObject3D(curve: Sketchable) {
        worldCurves.append(curve);
        
        guard let renderer = self.delegate as? Renderer else {
            print("Delegate of this view is not of type Renderer")
            return;
        }
        
        renderer.addObject3D(curve: curve)
    }*/
    
    /**
     Function to add a 3D curve to the renderer
     */
    func addLine3D(curve: Sketchable) {
        /*
        var points = [SIMD4<Float>]()

        for x in stride(from: -6.0, to: 6.0, by: 0.01) {
            let y = Float(5*sin(x));
            let z = Float(4.0);
            points.append(SIMD4<Float>(Float(x),y,z,1))
        }

        let lineVertices = preparePointsForRendering(points: points)
         */
        
        guard let renderer = self.delegate as? Renderer else {
            //FIXME: Add an error message
            print("Delegate is not of type Renderer")
            return;
        }
        
        // renderer.addVerticesLine(vertices: lineVertices)
    }
    
    /*
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
    }*/

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}
