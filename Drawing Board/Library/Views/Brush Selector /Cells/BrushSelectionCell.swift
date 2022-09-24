//
//  BrushCell.swift
//  Drawing Board
//
//  Created by Roman on 2022-09-22.
//

import UIKit

 class BrushSelectionCell: UICollectionViewCell, Reusable {
     
     override var isSelected: Bool {
         didSet {
             contentView.layer.borderWidth = isSelected ? 2 : 0
             contentView.layer.borderColor = isSelected ? UIColor.blue.cgColor : nil
         }
     }
     
     private lazy var brushColorView = UIView()
     
     override init(frame: CGRect) {
         super.init(frame: frame)
         
         brushColorView.translatesAutoresizingMaskIntoConstraints = false
         addSubview(brushColorView)
         
         [
            brushColorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            brushColorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            brushColorView.widthAnchor.constraint(equalTo: brushColorView.heightAnchor),
            brushColorView.leadingAnchor.constraint(equalToSystemSpacingAfter: safeAreaLayoutGuide.leadingAnchor, multiplier: 1),
         ].activate()
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented and will not be")
     }
     
     func setBrush(_ brush: Brush) {
         brushColorView.backgroundColor = brush.color
     }
     
     override func layoutSubviews() {
         super.layoutSubviews()
         
         contentView.layer.cornerRadius = contentView.bounds.width / 2
         contentView.layer.masksToBounds = true
         
         brushColorView.layer.cornerRadius = brushColorView.bounds.width / 2
         brushColorView.layer.masksToBounds = true
     }
 }
