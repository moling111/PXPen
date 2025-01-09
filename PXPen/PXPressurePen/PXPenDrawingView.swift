//
//  PXPenDrawingView.swift
//  PXPen
//
//  Created by gzj on 2025/1/8.
//

import Foundation
import UIKit

let writtingWidth: CGFloat = 10.0
let boardSimplifyPenStrokesThresholdAngle = 2.0
let boardSimplifyPenStrokesThresholdWidthDifference = 2.0
let deviceScaleFactor = 2.0

class PXPenDrawingView : UIView {
    
    let scene: PXPressureWritingLayer = PXPressureWritingLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isMultipleTouchEnabled = false
        scene.frame = self.bounds
        self.layer.addSublayer(scene)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point2 = touch.location(in: self)
        var pressure = 1.0
        let maximumPossibleForce = touch.maximumPossibleForce
        if maximumPossibleForce != 0 {
            let force = touch.force
            pressure = force/maximumPossibleForce
        }
        print("touchesBegan pressure: \(pressure)")
        let _ = scene.inputDevicePress(scenePos: point2, pressure: pressure)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point2 = touch.location(in: self)
        var pressure = 1.0
        let maximumPossibleForce = touch.maximumPossibleForce
        if maximumPossibleForce != 0 {
            let force = touch.force
            pressure = force/maximumPossibleForce
        }
        print("touchesMoved pressure: \(pressure)")
        let _ = scene.inputDeviceMove(scenePos: point2, pressure: pressure)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point2 = touch.location(in: self)
        var pressure = 1.0
        let maximumPossibleForce = touch.maximumPossibleForce
        if maximumPossibleForce != 0 {
            let force = touch.force
            pressure = force/maximumPossibleForce
        }
        print("touchesEnded pressure: \(pressure)")
        let _ = scene.inputDeviceRelease(scenePos: point2, pressure: pressure)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point2 = touch.location(in: self)
        var pressure = 1.0
        let maximumPossibleForce = touch.maximumPossibleForce
        if maximumPossibleForce != 0 {
            let force = touch.force
            pressure = force/maximumPossibleForce
        }
        print("touchesCancelled pressure: \(pressure)")
        let _ = scene.inputDeviceRelease(scenePos: point2, pressure: pressure)
    }
    
    
}
