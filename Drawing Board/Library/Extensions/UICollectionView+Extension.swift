//
//  UICollectionView+Extension.swift
//  Drawing Board
//
//  Created by Roman on 2022-09-22.
//

import UIKit


extension UICollectionView {
    func dequeueReusableCell<Cell: Reusable>(withType cellType: Cell.Type, forItemAt indexPath: IndexPath) -> Cell {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath) as? Cell else {
            fatalError("Could not dequeue reusable cell with \(Cell.reuseIdentifier) reuse identifier.")
        }

        return cell
    }
}
