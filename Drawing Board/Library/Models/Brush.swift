//
//  Brush.swift
//  Drawing Board
//
//  Created by Alina Biesiedina on 2022-09-22.
//

import UIKit


struct Brush: Identifiable, Hashable {
    var color: UIColor
    var width: CGFloat
    var drawDelay: CGFloat
    
    var id: String
    
    init(color: UIColor, width: CGFloat = 1, drawDelay: CGFloat = 0) {
        self.color = color
        self.width = width
        self.drawDelay = drawDelay
        self.id = UUID().uuidString
    }
}
