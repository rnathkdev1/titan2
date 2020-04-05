//
//  DrawableViewController.swift
//  SketchCAD
//
//  Created by Ramnath Pillai on 8/25/19.
//  Copyright © 2019 Oxymoron. All rights reserved.
//

import Foundation


//
//  WorldViewController.swift
//  SketchCAD
//
//  Created by Ramnath Pillai on 8/4/19.
//  Copyright © 2019 Oxymoron. All rights reserved.
//

import UIKit
import MetalKit

class DrawableViewController: UIViewController {
    
    // Does the drawing
    var renderer: Renderer!
    
    // Create the Metal View
    var canvas: MTKView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let mtkView = view as? MTKView else {
            print("View of Drawable controller is not an MTKView")
            return
        }
        
        canvas = mtkView;
        
        // Select the device to render with.  We choose the default device
        guard let defaultDevice = MTLCreateSystemDefaultDevice() else {
            print("Metal is not supported")
            return
        }
        
        canvas.device = defaultDevice
        canvas.backgroundColor = UIColor.white
        canvas.colorPixelFormat = .bgra8Unorm_srgb
        
        
        // Instantiate the renderer here and make it the delegate.
        guard let newRenderer = Renderer(canvas: mtkView) else {
            print("Renderer cannot be initialized")
            return
        }
        
        renderer = newRenderer
        canvas.delegate = renderer
        
        // Setup the gesture recognizer for Pencil
        let pencilGestureRecognizer = PencilGestureRecognizer(target: self, action: #selector(strokeUpdated(_:)))
        canvas.addGestureRecognizer(pencilGestureRecognizer)
        
        // Do any additional setup after loading the view.
        addDrawableObject()
    }
    
    @objc func strokeUpdated(_ strokeGesture: PencilGestureRecognizer) {
        
    }
    
    
    // FIXME: Remove and formalize this
    func addDrawableObject() {
        // Create a viewable cubic bezier curve
        let p0 = float3(1.0, 1.0, 1.0)
        let p1 = float3(2.0, 1.0, 1.0)
        let p2 = float3(3.0, 1.0, 1.0)
        let p3 = float3(4.0, 1.0, 1.0)
        
        let c = CubicBezierCurve(P0: p0, P1: p1, P2: p2, P3: p3)
        let skc = SketchableBezierCurve(curve: c)
        
        // Add this curve to the list
        guard let drawableCanvas = view as? DrawableView else {
            print("View is not DrawableView")
            return
        }
        
        // drawableCanvas.addObject3D(curve: skc);
        drawableCanvas.addObject3D(curve: SketchableBasePlane())
        drawableCanvas.addObject3D(curve: SketchableWireFrame())
        drawableCanvas.addObject3D(curve: SketchableSymmetryPlane())
        //drawableCanvas.addScreenCurve();
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
