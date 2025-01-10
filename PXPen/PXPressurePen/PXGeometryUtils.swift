//
//  PXGeometryUtils.swift
//  PXPen
//
//  Created by gzj on 2025/1/9.
//

import Foundation
import CoreGraphics

struct PXGeometryUtils {
    
    static func lineToPolygonF(line: PXLineF, width: CGFloat) -> PXPolygonF {
        
        let x1 = line.x1()
        let y1 = line.y1()
        
        let x2 = line.x2()
        let y2 = line.y2()
        
        let alpha = line.angle() * Double.pi / 180.0
        let hypothenuse = width / 2
        
        let opposite = sin(alpha) * hypothenuse //垂直方向上的偏差值
        let adjacent = cos(alpha) * hypothenuse //水平方向上的偏差值
        
        let p1a = CGPoint(x: x1 - adjacent, y: y1 - opposite)
        let p1b = CGPoint(x: x1 + adjacent, y: y1 + opposite)
        
        let p2a = CGPoint(x: x2 - adjacent, y: y2 - opposite)
//        let p2b = CGPoint(x: x2 + adjacent, y: y2 + opposite)
        
        let painterPath = CGMutablePath()
        painterPath.move(to: p1a)
        
        painterPath.addLine(to: p2a)
        var rectF = CGRect(x: x2 - hypothenuse, y: y2 - hypothenuse, width: width, height: width)
        painterPath.arcTo(rectF, startAngle: (90.0+line.angle()), endAngle: -180.0) //startAngle=(90.0+line.angle()),arcLength=-180.0
        
        painterPath.addLine(to: p1b)
        rectF = CGRect(x: x1 - hypothenuse, y: y1 - hypothenuse, width: width, height: width)
        painterPath.arcTo(rectF, startAngle: -1*(90.0-line.angle()), endAngle: -180.0)
        painterPath.closeSubpath()
        return PXPolygonF(path: painterPath)
    }
    
    static func lineToPolygonF(line: PXLineF, startWidth: CGFloat, endWidth: CGFloat) -> PXPolygonF {
        
        let x1 = line.x1()
        let y1 = line.y1()
        
        let x2 = line.x2()
        let y2 = line.y2()
        
        let alpha = line.angle() * Double.pi / 180.0
        let startHypothenuse = startWidth / 2
        let endHypothenuse = endWidth / 2
        
        let startOpposite = sin(alpha) * startHypothenuse //起始点垂直方向上的偏差值
        let startAdjacent = cos(alpha) * startHypothenuse //起始点水平方向上的偏差值
        
        let endOpposite = sin(alpha) * endHypothenuse //终点垂直方向上的偏差值
        let endAdjacent = cos(alpha) * endHypothenuse //终点水平方向上的偏差值
        
        let p1a = CGPoint(x: x1 - startAdjacent, y: y1 - startOpposite)
        let p1b = CGPoint(x: x1 + startAdjacent, y: y1 + startOpposite)
        
        let p2a = CGPoint(x: x2 - endAdjacent, y: y2 - endOpposite)
//        let p2b = CGPoint(x: x2 + endAdjacent, y: y2 + endOpposite)
        
        let painterPath = CGMutablePath()
        painterPath.move(to: p1a)
        
        var rectF = CGRect(x: x2 - endHypothenuse, y: y2 - endHypothenuse, width: endWidth, height: endWidth)
        painterPath.addLine(to: p2a)
        painterPath.arcTo(rectF, startAngle: (90.0 + line.angle()), endAngle: -180.0)
        
        rectF = CGRect(x: x1 - startHypothenuse, y: y1 - startHypothenuse, width: startWidth, height: startWidth)
        painterPath.addLine(to: p1b)
        painterPath.arcTo(rectF, startAngle: -1 * (90.0 - line.angle()), endAngle: -180.0)
        painterPath.closeSubpath()
        return PXPolygonF(path: painterPath)
    }
    
    static func lineToPolygonF(start: CGPoint, end: CGPoint, startWidth: CGFloat, endWidth: CGFloat) -> PXPolygonF {
        let lineF = PXLineF(p1: start, p2: end)
        return lineToPolygonF(line: lineF, startWidth: startWidth, endWidth: endWidth)
    }
    
    //返回三个点之间的角度
    static func angle(p1: CGPoint, p2: CGPoint, p3: CGPoint) -> Double {
        /*
         * 使用余弦定律计算三个点之间的角度：
         * cosB=(a^2+b^2-c^2)/(2ac)
         * B处的角度等于arccos((a^2+c^2-b^2)/(2*a*c)),其中a,b,c是三角形的边，分别于A,B,C相对应
         */
        
        let beta: Double
        let a = sqrt(pow(p2.x - p3.x, 2) + pow(p2.y - p3.y, 2))
        let b = sqrt(pow(p1.x - p3.x, 2) + pow(p1.y - p3.y, 2))
        let c = sqrt(pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2))
        if a == 0 || c == 0 {
            beta = 3.14159
        } else {
            beta = acos(max(-1.0, min(1.0, (a * a + c * c - b * b) / (2 * a * c))))
        }
        return 180.0 * beta / 3.14159
    }
    
    /**
     计算一条二次贝塞尔曲线，并以点集的形式返回 - p0:曲线的起点;p1:曲线的控制点;p2:曲线的终点;nPoints:近似曲线的点数，就是列表的长度
     */
    static func quadraticBezier(p0: CGPoint, p1: CGPoint, p2: CGPoint, nPoints: Int) -> [CGPoint] {
        var points = [CGPoint]()
        if nPoints <= 1 {
            return points
        }
        for i in 0..<(nPoints+1) {
            let percent = CGFloat(i)/CGFloat(nPoints)
            let point = quadraticBezierPoint(at: percent, start: p0, control: p1, end: p2)
            points.append(point)
        }
        return points
    }
    
    /**
     二阶贝塞尔曲线由三个控制点定义：B(t) = (1-t)²P₀ + 2t(1-t)P₁ + t²P₂‌ 其中t是一个介于0和1之间的参数。
     */
    static func quadraticBezierPoint(at t: CGFloat, start: CGPoint, control: CGPoint, end: CGPoint) -> CGPoint {
        let oneMinusT = 1 - t
        let oneMinusTSquared = oneMinusT * oneMinusT
        let tSquared = t * t
        let twoTimesOneMinusTTimesT = 2 * oneMinusT * t

        let x = oneMinusTSquared * start.x + twoTimesOneMinusTTimesT * control.x + tSquared * end.x
        let y = oneMinusTSquared * start.y + twoTimesOneMinusTTimesT * control.y + tSquared * end.y

        return CGPoint(x: x, y: y)
    }
    
    static func curveToPolygon(points: [PXPair], roundStart: Bool, roundEnd: Bool) -> PXPolygonF {
        let n_points = points.count
        switch n_points {
        case 0:
            return PXPolygonF(path: CGMutablePath())
        case 1:
            return lineToPolygonF(start: points[0].point, end: points[0].point, startWidth: points[0].width, endWidth: points[0].width)
        default:
            guard let startWidth = points.first?.width, let endWidth = points.last?.width else {
                return PXPolygonF(path: CGMutablePath())
            }
            var newPoints = [(CGPoint, CGPoint)]()
            let firstSegment = PXLineF(p1: points[0].point, p2: points[1].point)
            var startNormalLine = firstSegment.normalVector()
            startNormalLine.setLength(startWidth/2)
            newPoints.append((startNormalLine.p2, startNormalLine.p1 - CGPoint(x: startNormalLine.dx(), y: startNormalLine.dy())))

            for i in 1 ..< (n_points - 1) {
                var normalLine = PXLineF(p1: points[i-1].point, p2: points[i+1].point).normalVector()
                normalLine.setLength(points[i].width/2)
                let d1 = points[i].point + CGPoint(x: normalLine.dx(), y: normalLine.dy())
                let d2 = points[i].point - CGPoint(x: normalLine.dx(), y: normalLine.dy())
                newPoints.append((d1, d2))
            }
            
            //最后一个点和第一个点相似
            let lastSegment = PXLineF(p1: points[n_points - 2].point, p2: points[n_points - 1].point)
            var endNormalLine = lastSegment.normalVector()
            endNormalLine.setLength(endWidth/2)
            let d1 = points.last!.point + CGPoint(x: endNormalLine.dx(), y: endNormalLine.dy())
            let d2 = points.last!.point - CGPoint(x: endNormalLine.dx(), y: endNormalLine.dy())
            newPoints.append((d1, d2))
            
            let path = CGMutablePath()
            path.move(to: newPoints[0].0)
            for i in 1 ..< n_points {
                path.addLine(to: newPoints[i].0)
            }
            
            if roundEnd == true {
                let rectF = CGRect(x: points.last!.point.x - endWidth/2, y: points.last!.point.y - endWidth/2, width: endWidth, height: endWidth)
                path.arcTo(rectF, startAngle: (180.0 + lastSegment.angle()), endAngle: -180.0)
            } else {
                path.addLine(to: newPoints.last!.1)
            }
            
            let indexs = (0..<n_points).reversed()
            for i in indexs {
                path.addLine(to: newPoints[i].1)
            }
            
            if roundStart == true {
                let rectF = CGRect(x: points[0].point.x - startWidth/2, y: points[0].point.y - startWidth/2, width: startWidth, height: startWidth)
                path.arcTo(rectF, startAngle: (firstSegment.angle() - 90.0), endAngle: -180.0)
            } else {
                path.addLine(to: newPoints[0].0)
            }
            return PXPolygonF(path: path)
        }
    }
}


extension CGMutablePath {
    
    func arcTo(_ rect: CGRect, startAngle: Double, endAngle: Double) {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = rect.width/2
        let startAngle = (startAngle / 180 * Double.pi)
        let endAngle = startAngle + (endAngle/180*Double.pi)
        self.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
    }
}
