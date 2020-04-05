//
//  ColorConstants.swift
//  SketchCAD
//
//  Created by Ramnath Pillai on 9/1/19.
//  Copyright © 2019 Oxymoron. All rights reserved.
//

import Foundation

enum ColorConstants {
    static let worldCurve = SIMD4<Float> (1.0, 0.0, 0.0, 1.0)
    static let screenCurve = SIMD4<Float> (0.0, 1.0, 0.0, 1.0)
    static let basePlane = SIMD4<Float>(0.827, 0.827, 0.827, 0.4)
    static let baseWireFrame = SIMD4<Float>(0.0, 0.0, 0.0, 0.4)
    static let symmetryPlane = SIMD4<Float>(0.827, 0.827, 0.827, 0.3)
}

enum ColorIndex: Int, CaseIterable {
    case worldCurve
    case screenCurve
    case basePlane
    case symmetryPlane
    case baseWireFrame
    
    func getColorValues() -> SIMD4<Float> {
        switch self {
        case .worldCurve:
            return ColorConstants.worldCurve
        case .screenCurve:
            return ColorConstants.screenCurve
        case .basePlane:
            return ColorConstants.basePlane
        case .symmetryPlane:
            return ColorConstants.symmetryPlane
        case .baseWireFrame:
            return ColorConstants.baseWireFrame
        }
    }
}
