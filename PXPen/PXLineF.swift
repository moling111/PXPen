//
//  PXLineF.swift
//  PXPen
//
//  Created by gzj on 2025/1/8.
//

import Foundation

class PXLineF {
    
    let p1: CGPoint
    var p2: CGPoint

    init(p1: CGPoint, p2: CGPoint) {
        self.p1 = p1
        self.p2 = p2
    }
    
    func x1() -> CGFloat {
        return p1.x
    }
    
    func x2() -> CGFloat {
        return p2.x
    }
    
    func y1() -> CGFloat {
        return p1.y
    }
    
    func y2() -> CGFloat {
        return p2.y
    }
    
    func dx() -> CGFloat {
        return x2() - x1()
    }
    
    func dy() -> CGFloat {
        return y2() - y1()
    }
    
    func length() -> CGFloat {
        return hypot(dx(), dy())
    }
    
    func normalVector() -> PXLineF {
        return PXLineF(p1: p1, p2: p1 + CGPoint(x: dy(), y: -dx()))
    }
    
    func setLength(_ len: CGFloat) {
        let oldLength = length()
        if oldLength > 0 {
            p2 = CGPoint(x: x1() + len/oldLength * dx(), y: y1() + len/oldLength * dy())
        }
    }
    
    private func fuzzyCompare(p1: Double, p2: Double) -> Bool {
        let epsilon: Double = 1e-9 //这是一个示例epsilon值，你可以根据需要调整它
        let difference = abs(p1 - p2)
        let minAbs = min(abs(p1), abs(p2))
        return difference <= epsilon * max(1.0, minAbs) //这样可以处理非常小的数和非常大的数
    }
}
