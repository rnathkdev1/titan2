//
//  File.swift
//  SketchCAD
//
//  Created by Ramnath Pillai on 8/22/19.
//  Copyright © 2019 Oxymoron. All rights reserved.
//

import Foundation

public extension SIMD3 where Scalar == Float {
    static func * (left: SIMD3<Float>, right: Double) -> SIMD3<Float>{
        return left*Float(right);
    }
    
    
    static func * (right: Double, left: SIMD3<Float>) -> SIMD3<Float>{
        return Float(right) * left;
    }
    
    static func / (left: SIMD3<Float>, right: Double) -> SIMD3<Float>{
        return left/Float(right);
    }

    
}
