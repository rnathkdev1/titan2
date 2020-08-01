//
//  SketchableCurve.swift
//  SketchCAD
//
//  Created by Ramnath Pillai on 4/12/20.
//  Copyright © 2020 Oxymoron. All rights reserved.
//

import Foundation

protocol SketchableCurve: Sketchable {
    var sketchableVertices: [LineVertex] {get}
}
