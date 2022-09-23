//
//  CanvasView.swift
//  Drawing Board
//
//  Created by Alina Biesiedina on 2022-09-22.
//

import UIKit


class CanvasView: UIView {
    
    
    // MARK: - Properties
    
    private(set) var brush: Brush
    private var lines: [[CGPoint]] = []
    private var layers: [CALayer] = []
    
    
    // MARK: - Init
    
    init(brush: Brush) {
        self.brush = brush
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Public Methods
    
    func updateBrush(_ newBrush: Brush) {
        brush = newBrush
    }
    
    func clear() {
        layers.forEach { layer in
            layer.removeFromSuperlayer()
        }
        
        layers = []
    }
    
    func undoLast() {
        guard let lastLayer = layers.popLast() else {
            return
        }
        
        lastLayer.removeFromSuperlayer()
    }
    
    
    // MARK: - UIResponder
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lines.append([])
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        guard var lastLine = lines.popLast() else {
            return
        }
        
        
        let touchLocation = touch.location(in: self)

        lastLine.append(touchLocation)
        lines.append(lastLine)
        
        if brush.drawDelay == 0 {
            setNeedsDisplay()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard brush.drawDelay > 0 else {
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + brush.drawDelay, execute: { [weak self] in
            self?.drawPoints(self?.lines.last ?? [])
        })
    }
    
    // MARK: - Private Methods
    
    private func drawPoints(_ points: [CGPoint]) {
        guard points.isEmpty == false else {
            return
        }
        
        let path = UIBezierPath()
        
        for (index, point) in points.enumerated() {
            if index == 0 {
                path.move(to: point)
                continue
            }

            path.addLine(to: point)
        }
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = brush.color.cgColor
        shapeLayer.lineWidth = brush.width
        shapeLayer.path = path.cgPath
        
        layer.addSublayer(shapeLayer)
        layers.append(shapeLayer)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.duration = brush.drawTime
        shapeLayer.add(animation, forKey: "drawing_animation")
    }
    
    
}
