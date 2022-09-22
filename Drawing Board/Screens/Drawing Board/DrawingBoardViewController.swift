//
//  DrawingBoardViewController.swift
//  Drawing Board
//
//  Created by Alina Biesiedina on 2022-09-22.
//

import UIKit


class DrawingBoardViewController: UIViewController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let canvasView = CanvasView(brush: .init(color: .red, width: 5, drawDelay: 1))
        // No matter the color scheme, drawing is best on white canvas I guess?
        canvasView.backgroundColor = .white
        canvasView.backgroundColor = view.backgroundColor
        
        let brushSelectionView = BrusheSelectorView(brushes: .all) { [weak canvasView] brush in
            canvasView?.updateBrush(brush)
        }
        
        brushSelectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(brushSelectionView)
        
        [
            brushSelectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            brushSelectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            brushSelectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            brushSelectionView.heightAnchor.constraint(equalToConstant: 50)
        ].activate()
        
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(canvasView)
        [
            canvasView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            canvasView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            canvasView.bottomAnchor.constraint(equalTo: brushSelectionView.topAnchor),
            canvasView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ].activate()
        
        canvasView.layer.shadowRadius = 10
        canvasView.layer.shadowColor = UIColor.black.cgColor
        canvasView.layer.shadowOpacity = 0.8
        
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
