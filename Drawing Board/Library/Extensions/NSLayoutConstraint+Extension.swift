//
//  File.swift
//  Drawing Board
//
//  Created by Roman on 2022-09-22.
//

import UIKit


extension Array where Element == NSLayoutConstraint {
    func activate() {
        NSLayoutConstraint.activate(self)
    }
}
