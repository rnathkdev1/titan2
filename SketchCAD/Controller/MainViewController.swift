//
//  WorldViewController.swift
//  SketchCAD
//
//  Created by Ramnath Pillai on 8/4/19.
//  Copyright © 2019 Oxymoron. All rights reserved.
//

import UIKit
import MetalKit

class MainViewController: UIViewController {
    
    // Does the drawing
    var drawableController: DrawableViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create the DrawableViewController
        self.drawableController = DrawableViewController()

        // Do any additional setup after loading the view.
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
