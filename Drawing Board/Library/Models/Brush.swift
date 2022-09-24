//
//  Brush.swift
//  Drawing Board
//
//  Created by Roman on 2022-09-22.
//

import UIKit


struct Brush: Equatable, Identifiable, Hashable {
    var color: UIColor
    var width: CGFloat
    var drawDelay: CGFloat
    var drawTime: CGFloat
    
    var id: String
    
    init(color: UIColor, width: CGFloat = 1, drawDelay: CGFloat = 0, drawTime: CGFloat = 1) {
        self.color = color
        self.width = width
        self.drawDelay = drawDelay
        self.drawTime = drawTime
        
        self.id = UUID().uuidString
    }
}
