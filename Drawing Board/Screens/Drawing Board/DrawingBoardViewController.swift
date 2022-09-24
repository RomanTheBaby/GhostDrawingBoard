//
//  DrawingBoardViewController.swift
//  Drawing Board
//
//  Created by Roman on 2022-09-22.
//

import UIKit


class DrawingBoardViewController: UIViewController {
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let allBrushes = [Brush].all
        
        let initialBrush = allBrushes[0]
        
        let canvasView = GhostCanvasView(brush: initialBrush)
        // No matter the color scheme, drawing is best on white canvas I guess?
        canvasView.backgroundColor = .white
        view.backgroundColor = .systemGray5
        
        let instrumentsView = InstrumentsView(
            brushes: allBrushes,
            initiallySelectedBrush: initialBrush
        ) { [weak canvasView] actionType in
            
            switch actionType {
            case .changedBrush(let brush):
                canvasView?.updateBrush(brush)
                
            case .undo:
                canvasView?.undoLast()
                
            case .clear:
                canvasView?.clear()
            }
            
        }
        
        instrumentsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(instrumentsView)
        
        [
            instrumentsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            instrumentsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            instrumentsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            instrumentsView.heightAnchor.constraint(equalToConstant: 50)
        ].activate()
        
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(canvasView)
        [
            canvasView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            canvasView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            canvasView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            canvasView.bottomAnchor.constraint(greaterThanOrEqualTo: instrumentsView.topAnchor, constant: -16)
        ].activate()
        
        canvasView.layer.shadowRadius = 5
        canvasView.layer.shadowColor = UIColor.black.cgColor
        canvasView.layer.shadowOpacity = 0.8
        canvasView.layer.cornerRadius = 8
        canvasView.layer.masksToBounds = true
        
    }
    
}

private extension Array where Element == Brush {
    static var all: [Element] {
        [
            Brush(color: .red, width: 5, drawDelay: 1),
            Brush(color: .blue, width: 7, drawDelay: 3),
            Brush(color: .green, width: 9, drawDelay: 5),
        ]
    }
}
