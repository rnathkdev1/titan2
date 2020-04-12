//
//  LineVertex.swift
//  SketchCAD
//
//  Created by Ramnath Pillai on 4/6/20.
//  Copyright © 2020 Oxymoron. All rights reserved.
//

import Foundation

struct LineVertex {
    var thisVertex: SIMD4<Float> = SIMD4<Float>(-1, -1, -1, -1)
    var nextVertex: SIMD4<Float> = SIMD4<Float>(-1, -1, -1, -1)
    var prevVertex: SIMD4<Float> = SIMD4<Float>(-1, -1, -1, -1)
    var colorIndex: ushort = 0
    var direction: Int8
}
