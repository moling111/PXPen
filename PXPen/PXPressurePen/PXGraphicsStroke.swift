//
//  PXGraphicsStroke.swift
//  PXPen
//
//  Created by gzj on 2025/1/9.
//

import Foundation

class PXGraphicsStroke {
    
    var m_scaleFactor: Double = 1.0
    var m_antiScaleRatio: Double = 1.0
    var m_polygons = [PXGraphicsPolygonItem]()
    var m_receivedPoints = [PXPair]()//原始点
    var m_drawnPoints = [PXPair]() //包含插值的所有点集
    weak var m_scene: PXPressureWritingLayer?
    
    init(scaleFactor: Double, scene: PXPressureWritingLayer?) {
        self.m_scaleFactor = scaleFactor
        self.m_antiScaleRatio = 1.0/m_scaleFactor
        self.m_scene = scene
    }
    
    func hasAlpha() -> Bool {
        return m_polygons.count > 0 && m_polygons[0].color().alpha != 1.0
    }
    
    func polygons() -> [PXGraphicsPolygonItem] {
        return m_polygons
    }
    
    func deepCopy() -> PXGraphicsStroke {
        let clone = PXGraphicsStroke(scaleFactor: m_scaleFactor, scene: m_scene)
        return clone
    }
    
    func remove(_ item: PXGraphicsPolygonItem) {
        m_polygons.removeAll {
            $0.identifier == item.identifier
        }
    }
    
    func clear() {
        m_polygons.removeAll()
    }
    
    func addPolygonItem(_ polygonItem: PXGraphicsPolygonItem) {
        remove(polygonItem)
        m_polygons.append(polygonItem)
    }
    
    func points() -> [PXPair] {
        return m_drawnPoints
    }
    
    
}
