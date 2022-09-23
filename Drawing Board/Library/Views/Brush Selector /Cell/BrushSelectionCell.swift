//
//  BrushCell.swift
//  Drawing Board
//
//  Created by Alina Biesiedina on 2022-09-22.
//

import UIKit

 class BrushSelectionCell: UICollectionViewCell, Reusable, NibLoadable {
     
     @IBOutlet private var brushContainerView: UIView!
     @IBOutlet private var brushColorView: UIView!
     
     override var isSelected: Bool {
         didSet {
             brushContainerView.layer.borderWidth = isSelected ? 2 : 0
             brushContainerView.layer.borderColor = isSelected ? UIColor.blue.cgColor : nil
         }
     }
     
     func setBrush(_ brush: Brush) {
         brushColorView.backgroundColor = brush.color
     }
     
     override func layoutSubviews() {
         super.layoutSubviews()
         
         brushColorView.layer.cornerRadius = brushColorView.bounds.width / 2
         brushColorView.layer.masksToBounds = true

         brushContainerView.layer.cornerRadius = brushContainerView.bounds.width / 2
         brushContainerView.layer.masksToBounds = true
     }
 }
