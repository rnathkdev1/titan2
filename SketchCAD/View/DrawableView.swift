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
    
    func addLine() {
        
        var points = [SIMD4<Float>]()

        for x in stride(from: -6.0, to: 6.0, by: 0.01) {
            let y = Float(5*sin(x));
            let z = Float(4.0);
            points.append(SIMD4<Float>(Float(x),y,z,1))
        }
        
        /*
        let points = [
            SIMD4<Float>(6,5,5,1),
            SIMD4<Float>(-6,5,5,1)
        ];*/
        
        
        let lineVertices = preparePointsForRendering(points: points)
        guard let renderer = self.delegate as? Renderer else {
            //FIXME: Add an error message
            print("Delegate is not Renderer")
            return;
        }
        
        renderer.addVerticesLine(vertices: lineVertices)
    }
    
    func preparePointsForRendering(points: [SIMD4<Float>])->[LineVertex] {
        var indexedVertices = [LineVertex]()
        // Repeat each point
        for i in 0..<points.count {
            let thisPoint = points[i]
            var nextVertex = SIMD4<Float>(-1, -1, -1, -1)
            var prevVertex = SIMD4<Float>(-1, -1, -1, -1)
            
            if i+1 < points.count {
                nextVertex = points [i+1]
            }
            
            if i-1 >= 0 {
                prevVertex = points[i-1]
            }
            
            let thisVertex = LineVertex(thisVertex: thisPoint, nextVertex: nextVertex, prevVertex: prevVertex, direction: 1, colorIndex: UInt16(ColorIndex.screenCurve.rawValue));
            let repeatVertex = LineVertex(thisVertex: thisPoint, nextVertex: nextVertex, prevVertex: prevVertex, direction: -1, colorIndex: UInt16(ColorIndex.screenCurve.rawValue));
            indexedVertices.append(thisVertex);
            indexedVertices.append(repeatVertex);
        }
        
        return indexedVertices
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}
