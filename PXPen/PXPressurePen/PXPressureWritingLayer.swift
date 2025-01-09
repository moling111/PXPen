//
//  PXPressureWritingLayer.swift
//  PXPen
//
//  Created by gzj on 2025/1/9.
//

import UIKit
import QuartzCore

class PXPressureWritingLayer: CALayer {
    
    var m_isInputDeviceIsPressed = false
    var m_currentStroke: PXGraphicsStroke? = nil
    var m_tempPolygon: PXGraphicsPolygonItem?
    var m_lastPolygon: PXGraphicsPolygonItem?
    var polygonItems = [PXGraphicsItem]()
    var m_addedItems = [PXGraphicsItem]()
    var m_previousPolygonItems = [PXGraphicsPolygonItem]()
    var m_currentPolygon: PXGraphicsPolygonItem?
    var m_removedItems = [PXGraphicsItem]()
    var m_previousPoint: CGPoint?
    var m_previousWidth: CGFloat = -1.0
    var m_drawWithCompass = false//圆规绘制
    var m_arcPolygonItem: PXGraphicsPolygonItem?
    var m_distanceFromLastStrokePoint: CGFloat = 0
    var pathCount = 0
    var drawLayer: CAShapeLayer?
    
    func initDrawLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.red.cgColor
        self.addSublayer(layer)
        return layer
    }
    
    
    
    func inputDevicePress(scenePos:CGPoint, pressure:CGFloat) -> Bool {
        
        
        return true
    }
    
    
    func inputDeviceMove(scenePos:CGPoint, pressure:CGFloat) -> Bool {
        
        
        
        return true
    }
    
    func inputDeviceRelease(scenePos:CGPoint, pressure:CGFloat) -> Bool {
        
        
     
        return true
    }
}
