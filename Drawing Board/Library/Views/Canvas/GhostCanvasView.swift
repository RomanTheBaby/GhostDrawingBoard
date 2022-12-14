//
//  GhostCanvasView.swift
//  Drawing Board
//
//  Created by Roman on 2022-09-22.
//

import UIKit


/// This canvas view supports only drawing with delay
class GhostCanvasView: UIView {
    
    private enum Contants {
        enum Eraser {
            static let delay: CGFloat = 2
        }
    }
    
    // MARK: - Properties
    
    private(set) var brush: Brush
    private var drawingLayers: [CALayer] = []
    private var pendingDrawings: [Drawing] = []
    /// Layers that are scheduled to be deleted
    private var removableLayers: [[CALayer]] = []

    private let eraserDelay: CGFloat
    
    
    // MARK: - Init
    
    init(brush: Brush, eraserDelay: CGFloat = Contants.Eraser.delay) {
        self.brush = brush
        self.eraserDelay = eraserDelay
        
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
        guard drawingLayers.isEmpty == false else {
            return
        }
        
        removableLayers.append(drawingLayers)
        drawingLayers = []
        
        DispatchQueue.main.asyncAfter(deadline: .now() + eraserDelay) { [weak self] in
            self?.removableLayers.first?.forEach { layer in
                layer.removeFromSuperlayer()
            }
            
            self?.removableLayers.removeFirst()
        }
    }
    
    func undoLast() {
        guard let lastLayer = drawingLayers.popLast() else {
            return
        }
        
        lastLayer.removeFromSuperlayer()
    }
    
    
    // MARK: - UIResponder
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        
        let newDrawing = Drawing(brush: brush, points: [touchLocation])
        pendingDrawings.append(newDrawing)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        guard let currentDrawing = pendingDrawings.popLast() else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        
        currentDrawing.points.append(touchLocation)
        pendingDrawings.append(currentDrawing)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let latestDrawing = pendingDrawings.last, let touch = touches.first else {
            return
        }
        
        if latestDrawing.points.count > 1 {
            let touchLocation = touch.location(in: self)
            latestDrawing.points.append(touchLocation)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + latestDrawing.drawDelay) { [weak self, weak latestDrawing] in
            guard let self = self, let latestDrawing = latestDrawing else {
                return
            }
            
            self.draw(latestDrawing)
            
            if let index = self.pendingDrawings.firstIndex(of: latestDrawing) {
                self.pendingDrawings.remove(at: index)
            }
        }
        
    }
    
    // MARK: - Private Methods
    
    private func draw(_ drawing: Drawing) {
        guard drawing.points.isEmpty == false else {
            return
        }
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = drawing.brush.color.cgColor
        shapeLayer.lineWidth = drawing.brush.width
        shapeLayer.path = drawing.path.cgPath
        
        layer.addSublayer(shapeLayer)
        drawingLayers.append(shapeLayer)
        
        if drawing.points.count > 1 && drawing.brush.drawTime > 0 {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0
            animation.duration = drawing.brush.drawTime
            shapeLayer.add(animation, forKey: "drawing_animation")
        }
    }
    
    
}
