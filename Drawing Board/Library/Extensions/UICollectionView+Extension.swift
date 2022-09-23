//
//  UICollectionView+Extension.swift
//  Drawing Board
//
//  Created by Alina Biesiedina on 2022-09-22.
//

import UIKit


protocol ReusableCell: UICollectionViewCell, Reusable {
}

extension UICollectionView {
    func dequeueReusableCell<Cell: Reusable>(withType cellType: Cell.Type, forItemAt indexPath: IndexPath) -> Cell {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath) as? Cell else {
            fatalError("Could not dequeue reusable cell with \(Cell.reuseIdentifier) reuse identifier.")
        }

        return cell
    }

    func register<Cell: Reusable & NibLoadable>(cell: Cell.Type) {
        register(Cell.nib, forCellWithReuseIdentifier: Cell.reuseIdentifier)
    }
}
