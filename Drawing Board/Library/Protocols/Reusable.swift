//
//  Reusable.swift
//  Drawing Board
//
//  Created by Alina Biesiedina on 2022-09-22.
//

import Foundation


protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        String(describing: Self.self)
    }
}
