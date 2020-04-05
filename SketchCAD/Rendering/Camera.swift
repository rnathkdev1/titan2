//
//  Camera.swift
//  SketchCAD
//
//  Created by Ramnath Pillai on 8/11/19.
//  Copyright © 2019 Oxymoron. All rights reserved.
//

import Foundation
import UIKit
import MetalKit

// The initial UP vector is z axis.
// Camera looks at origin
// up - forward - left is the righthanded coordinate space followed here
class Camera {
    
    // MARK: Camera lens properties
    private let nearZ: Float = Float(0.1)
    private let farZ: Float = Float(1000.0)
    
    private(set) var viewSize: CGSize {
        didSet {
            updateCamera()
        }
    }
    
    // Vertical view angle in radians
    private var verticalViewAngle: Float {
        didSet {
            updateCamera()
        }
    }
    
    private var zoom: Float {
        didSet {
            updateCamera()
        }
    }
    
    // MARK: Position properties
    // Position in space
    private var position: float3 {
        didSet {
            updateCamera()
        }
    }
    
    // Unit vector that points forward
    private var forward: float3 {
        didSet {
            updateCamera()
        }
    }
    
    // Unit vector that points up
    private var up: float3 {
        didSet {
            updateCamera()
        }
    }
    
    // MARK: Matrices
    private(set) var projectionMatrix: matrix_float4x4
    private(set) var viewMatrix: matrix_float4x4
    
    // Initializer for camera
    init(canvas: MTKView) {
        self.viewSize = canvas.bounds.size
        let aspectRatio = Float(viewSize.width/viewSize.height)
        self.verticalViewAngle = radians_from_degrees(45)
        self.zoom = 1.0
        self.position = float3(20, 20, 0)
        let lookAt = float3(0, 0, 0)
        self.up = float3(0, 0, 1)
        self.forward = normalize(lookAt - self.position);
        
        self.projectionMatrix = matrix_perspective(zoom * verticalViewAngle, aspectRatio, nearZ, farZ)
        
        self.viewMatrix = matrix_look_at(position[0], position[1], position[2],
                                         lookAt[0], lookAt[1], lookAt[2],
                                         up[0], up[1], up[2]);
    }
    
    // Update projection and view matrices.
    func updateCamera() {
        let aspectRatio = Float(viewSize.width/viewSize.height)
        let lookAt = self.position + forward;
        self.projectionMatrix = matrix_perspective(zoom * verticalViewAngle, aspectRatio, nearZ, farZ)
        self.viewMatrix = matrix_look_at(position[0], position[1], position[2],
                                         lookAt[0], lookAt[1], lookAt[2],
                                         up[0], up[1], up[2]);
    }
    
    func updateViewFromBounds(size: CGSize) {
        self.viewSize = size;
    }
}
