//
//  Drawing.swift
//  Drawing Board
//
//  Created by Roman on 2022-09-23.
//

import UIKit


class Drawing: Equatable {
    
    
    // MARK: - Public Properties
    
    let brush: Brush
    var points: [CGPoint]
    
    var drawDelay: CGFloat {
        brush.drawDelay
    }
    
    var path: UIBezierPath {
        guard points.count > 1 else {
            let radius = brush.width
            let point = points[0]
            let rect = CGRect(x: point.x - (radius / 2), y: point.y - (radius / 2), width: radius, height: radius)
            return UIBezierPath(ovalIn: rect)
        }
        
        let path = UIBezierPath()
        
        for (index, point) in points.enumerated() {
            if index == 0 {
                path.move(to: point)
                continue
            }
            
            path.addLine(to: point)
        }
        
        return path
    }

    
    // MARK: - Init
    
    init(brush: Brush, points: [CGPoint] = []) {
        self.brush = brush
        self.points = points
    }
    
    
    // MARK: - Equatable
    
    static func == (lhs: Drawing, rhs: Drawing) -> Bool {
        lhs.brush == rhs.brush
        && lhs.points == rhs.points
    }
    
    
}
