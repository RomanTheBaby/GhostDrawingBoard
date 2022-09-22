//
//  File.swift
//  Drawing Board
//
//  Created by Alina Biesiedina on 2022-09-22.
//

import UIKit


extension UIView {
    func embed(_ anotherView: UIView, layoutGuide: UILayoutGuide? = nil) {
        anotherView.translatesAutoresizingMaskIntoConstraints = false
        
        if anotherView.superview !== self {
            addSubview(anotherView)
        }
        
        [
            anotherView.leadingAnchor.constraint(equalTo: layoutGuide?.leadingAnchor ?? leadingAnchor),
            anotherView.trailingAnchor.constraint(equalTo: layoutGuide?.trailingAnchor ?? trailingAnchor),
            anotherView.topAnchor.constraint(equalTo: layoutGuide?.topAnchor ?? topAnchor),
            anotherView.bottomAnchor.constraint(equalTo: layoutGuide?.bottomAnchor ?? bottomAnchor),
        ].activate()
    }
}

extension Array where Element == NSLayoutConstraint {
    func activate() {
        NSLayoutConstraint.activate(self)
    }
}
