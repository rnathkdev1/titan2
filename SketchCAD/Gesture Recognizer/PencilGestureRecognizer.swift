//
//  PencilGestureRecognizer.swift
//  SketchCAD
//
//  Created by Ramnath Pillai on 9/4/19.
//  Copyright © 2019 Oxymoron. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

class PencilGestureRecognizer: UIGestureRecognizer {
    
    /// Touch that we are currently tracking
    var currentTouch: UITouch!
    
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        
        // This recognizer only recognizes Apple Pencil touches
        self.allowedTouchTypes = [UITouch.TouchType.pencil.rawValue as NSNumber]
    }
    
    /**
     This function checks whether we care about the touches.
     It also appends the touches to the stroke that we are building.
     */
    func appendTouches (_ touches: Set<UITouch>, with event: UIEvent) -> Bool {
        if let touch = currentTouch {
            
            // If the touch does not contain the tracked touch,
            // ignore.
            if !touches.contains(touch) {
                return false;
            }
        }
        return true;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        print("Touches Began with number of touches: \(touches.count)")
        
        // Track a new touch if there is none that is already being tracked.
        // If a second touch starts now, dont track it.
        if currentTouch == nil {
            // Track a touch
            currentTouch = touches.first
        }
        
        if appendTouches(touches, with: event) {
            state = .began
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        print("Touches Moved with number of touches: \(touches.count)")
        if appendTouches(touches, with: event) {
            state = .changed
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        print("Touches Ended with number of touches: \(touches.count)")
        if appendTouches(touches, with: event) {
            state = .ended
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        if appendTouches(touches, with: event) {
            state = .cancelled
        }
    }
    
    override func reset() {
        currentTouch = nil
        super.reset()
    }
}
