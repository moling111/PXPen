//
//  PXPointF.swift
//  PXPen
//
//  Created by gzj on 2025/1/8.
//

import Foundation

extension CGPoint {

    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    
}

