//
//  PXGraphicsItem.swift
//  PXPen
//
//  Created by gzj on 2025/1/8.
//

import UIKit

class PXGraphicsItem {
    let identifier: String
    init() {
        self.identifier = UUID().uuidString
    }
}

class PXGraphicsPolygonItem: PXGraphicsItem {
    
    var polygon: PXPolygonF?
    var m_color = PXColor.init(color: .red, alpha: 1.0)
    var m_originalLine: PXLineF?
    var m_originalWidth: CGFloat
    var m_isNominalLine: Bool
    weak var m_group: PXGraphicsStrokesGroup?
    weak var m_stroke: PXGraphicsStroke?
    var isLine = false
    
    init(polygon: PXPolygonF?, m_color: PXColor? = nil, m_originalLine: PXLineF?, m_originalWidth: CGFloat, m_isNominalLine: Bool) {
        self.polygon = polygon
        self.m_color = m_color ?? PXColor.init(color: .red, alpha: 1.0)
        self.m_originalLine = m_originalLine
        self.m_originalWidth = m_originalWidth
        self.m_isNominalLine = m_isNominalLine
        if polygon == nil, m_originalLine != nil {
            let path = CGMutablePath()
            path.move(to: m_originalLine!.p1)
            path.addLine(to: m_originalLine!.p2)
            self.polygon = PXPolygonF(path: path)
            isLine = true
        }
        super.init()
    }
    
    func setColor(_ color: PXColor) {
        self.m_color = color
    }
    
    func color() -> PXColor {
        return m_color
    }
    
    func originalLine() -> PXLineF? {
        return m_originalLine
    }
    
    func originalWidth() -> CGFloat {
        return m_originalWidth
    }
    
    func isNominalLine() -> Bool {
        return m_isNominalLine
    }
    
    func deepCopy() -> PXGraphicsPolygonItem {
        let copy = PXGraphicsPolygonItem(polygon: polygon, m_originalLine: m_originalLine, m_originalWidth: m_originalWidth, m_isNominalLine: m_isNominalLine)
        return copy
    }
    
    func clearStroke() {
        if let m_stroke = m_stroke {
            m_stroke.remove(self)
            if m_stroke.polygons().isEmpty == true {
                self.m_stroke = nil
            }
        }
    }
    
    func setStroke(_ stroke: PXGraphicsStroke) {
        clearStroke()
        m_stroke = stroke
        stroke.addPolygonItem(self)
    }
    
    func setStrokeGroup(_ group: PXGraphicsStrokesGroup) {
        m_group = group
    }
    
   
    
    func boundRect() -> CGRect {
        return self.polygon?.path.boundingBox ?? .zero
    }
    
    
}

class PXGraphicsStrokesGroup: PXGraphicsItem {
    
    var isSelected = false
    var m_items = [PXGraphicsPolygonItem]()
    
    func childItems() -> [PXGraphicsPolygonItem] {
        return [PXGraphicsPolygonItem]()
    }
    
    func addToGroup(_ item: PXGraphicsPolygonItem) {
        m_items.append(item)
    }
    
    func removeFromGroup(_ item: PXGraphicsPolygonItem) {
        m_items.removeAll { tmpItem in
            tmpItem.identifier == item.identifier
        }
    }
}



