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
    
    func polygonToPolygonItem(_ polygonF: PXPolygonF) -> PXGraphicsPolygonItem {
        let polygonItem = PXGraphicsPolygonItem(polygon: polygonF, m_originalLine: nil, m_originalWidth: -1, m_isNominalLine: false)
        initPolygonItem(polygonItem)
        return polygonItem
    }
    
    private func initPolygonItem(_ polygonItem: PXGraphicsPolygonItem) {
        polygonItem.setColor(PXColor(color: .red, alpha: 1.0))
    }
    
    func moveTo(pointF: CGPoint) {
        m_previousPoint = pointF
        m_previousWidth = -1.0
        m_arcPolygonItem = nil
        m_drawWithCompass = false
        m_previousPolygonItems.removeAll()
    }
    
    func drawLineTo(pEndPoint: CGPoint, pWidth: CGFloat) {
        drawLineTo(pEndPoint: pEndPoint, startWidth: pWidth, endWidth: pWidth)
    }
    
    func drawLineTo(pEndPoint: CGPoint, startWidth: CGFloat, endWidth: CGFloat) {
        guard let m_previousPoint = self.m_previousPoint else {
            #if DEBUG
            fatalError()
            #endif
            return
        }
        if m_previousWidth == -1.0 {
            m_previousWidth = startWidth
        }
        let initialWidth: CGFloat
        if startWidth == endWidth {
            initialWidth = m_previousWidth
        } else {
            initialWidth = startWidth
        }
        
        let polygonItem = lineToPolygonItem(line: PXLineF(p1: m_previousPoint, p2: pEndPoint), startWidth: initialWidth, endWidth: endWidth)
        addPolygonItemToCurrentStroke(polygonItem)
        self.m_previousPoint = pEndPoint
        m_previousWidth = endWidth
    }
    
    
    func lineToPolygonItem(line: PXLineF, startWidth: CGFloat, endWidth: CGFloat) -> PXGraphicsPolygonItem {
        let polygonItem = PXGraphicsPolygonItem(polygon: nil, m_originalLine: line, m_originalWidth: endWidth, m_isNominalLine: true)
        initPolygonItem(polygonItem)
        return polygonItem
    }
    
    func drawCurve(_ points:[QPair]) {
        guard let lastPoint = points.last else {
            #if DEBUG
            fatalError()
            #endif
            return
        }
       let polygonItem = curveToPolygonItem(points)
        addPolygonItemToCurrentStroke(polygonItem)
        drawPoly(polygonItem)
        m_previousPoint = lastPoint.point
        m_previousWidth = lastPoint.width
    }
    
    func curveToPolygonItem(_ points:[QPair]) ->HGraphicsPolygonItem {
        let polygonF = UBGeometryUtils.curveToPolygon(points: points, roundStart: true, roundEnd: true)
        return polygonToPolygonItem(polygonF)
    }
    
    func addPolygonItemToCurrentStroke(_ polygonItem: PXGraphicsPolygonItem) {
        
        m_lastPolygon = polygonItem
        m_addedItems.append(polygonItem)
        
        polygonItems.append(polygonItem)
        
        if m_currentStroke == nil {
            m_currentStroke = HGraphicsStroke(scaleFactor: deviceScaleFactor, scene: self)
        }
        polygonItem.setStroke(m_currentStroke!)
        m_previousPolygonItems.append(polygonItem)
    }
    
    func lineToPolygonItem(line:QLineF, startWidth:CGFloat, endWidth:CGFloat) -> HGraphicsPolygonItem {
        let polygonItem = HGraphicsPolygonItem(polygon: nil, m_originalLine: line, m_originalWidth: endWidth, m_isNominalLine: true)
        initPolygonItem(polygonItem)
        return polygonItem
    }
    
    func drawCurve(_ points:[QPair]) {
        guard let lastPoint = points.last else {
            #if DEBUG
            fatalError()
            #endif
            return
        }
       let polygonItem = curveToPolygonItem(points)
        addPolygonItemToCurrentStroke(polygonItem)
        drawPoly(polygonItem)
        m_previousPoint = lastPoint.point
        m_previousWidth = lastPoint.width
    }
    
    func curveToPolygonItem(_ points:[QPair]) ->HGraphicsPolygonItem {
        let polygonF = UBGeometryUtils.curveToPolygon(points: points, roundStart: true, roundEnd: true)
        return polygonToPolygonItem(polygonF)
    }
    
    func addPolygonItemToCurrentStroke(_ polygonItem:HGraphicsPolygonItem) {
//
//        for previous in m_previousPolygonItems {
//            polygonItem.substract(previous)
//        }
        
        m_lastPolygon = polygonItem
        m_addedItems.append(polygonItem)
        
        polygonItems.append(polygonItem)
        
        if m_currentStroke == nil {
            m_currentStroke = HGraphicsStroke(scaleFactor: deviceScaleFactor, scene: self)
        }
        polygonItem.setStroke(m_currentStroke!)
        m_previousPolygonItems.append(polygonItem)
    }
    
    func simplifyCurrentStroke() {
        guard let m_currentStroke = m_currentStroke else {
            #if DEBUG
            fatalError()
            #endif
           return
        }
        
        guard let simplerStroke = m_currentStroke.simplify(deviceScaleFactor) else {
            #if DEBUG
//            fatalError()
            #endif
            return
        }
        let polygons = m_currentStroke.polygons()
        for poly in polygons {
            m_previousPolygonItems.removeAll { item in
                item.identifier == poly.identifier
            }
            
            polygonItems.removeAll { item in
                item.identifier == poly.identifier
            }
        }
        self.m_currentStroke = simplerStroke
        let simple_polygons = simplerStroke.polygons()
        for poly in simple_polygons {
            polygonItems.append(poly)
            m_previousPolygonItems.append(poly)
        }
    }
    
    
    func drawPoly(_ item:HGraphicsPolygonItem) {
        let mutalPath = CGMutablePath()
        if let path = self.drawLayer?.path {
            mutalPath.addPath(path)
        }
        if let path = item.polygon?.path {
            mutalPath.addPath(path)
        }
        self.drawLayer?.path = mutalPath
        
        
        
//        pathCount += 1
//
//        let scale = UIScreen.main.scale
//        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, scale)
//        guard let context = UIGraphicsGetCurrentContext() else {
//            UIGraphicsEndImageContext()
//            return
//        }
//        context.setBlendMode(.copy)
//        self.render(in: context)
//        if let path = item.polygon?.path {
//            let bezierPath = UIBezierPath.init(cgPath: path)
////            if pathCount%2 == 0 {
//                UIColor.red.setFill()
////            } else {
////                UIColor.blue.setFill()
////            }
//            bezierPath.fill()
//
//        }
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        self.contents = image?.cgImage
    }
    
    
    func drawPoly(_ item:HGraphicsPolygonItem , color:UIColor) {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return
        }
        context.setBlendMode(.copy)
        context.setStrokeColor(color.cgColor)
        
        self.render(in: context)
        if let path = item.polygon?.path {
            let bezierPath = UIBezierPath.init(cgPath: path)
//            color.setFill()
//            self.fillColor = color.cgColor
            if item.isLine == true {
                print("drawPoly color")
                bezierPath.lineWidth = item.originalWidth()
                
            }
            bezierPath.stroke()
            
            
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.contents = image?.cgImage
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
