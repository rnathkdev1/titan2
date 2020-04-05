//
//  ColorConstants.swift
//  SketchCAD
//
//  Created by Ramnath Pillai on 9/1/19.
//  Copyright © 2019 Oxymoron. All rights reserved.
//

import Foundation

enum ColorConstants {
    static let worldCurve = float4 (1.0, 0.0, 0.0, 1.0)
    static let screenCurve = float4 (0.0, 1.0, 0.0, 1.0)
    static let basePlane = float4(0.827, 0.827, 0.827, 0.4)
    static let baseWireFrame = float4(0.0, 0.0, 0.0, 0.4)
    static let symmetryPlane = float4(0.827, 0.827, 0.827, 0.3)
}

enum ColorIndex: Int, CaseIterable {
    case worldCurve
    case screenCurve
    case basePlane
    case symmetryPlane
    case baseWireFrame
    
    func getColorValues() -> float4 {
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
