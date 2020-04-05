//
//  Sketchable.swift
//  SketchCAD
//
//  Created by Ramnath Pillai on 8/26/19.
//  Copyright © 2019 Oxymoron. All rights reserved.
//

import Foundation
import MetalKit

protocol Sketchable {
    var sketchableVertices: [Vertex] {get}
    var primitiveType: MTLPrimitiveType {get}
}
