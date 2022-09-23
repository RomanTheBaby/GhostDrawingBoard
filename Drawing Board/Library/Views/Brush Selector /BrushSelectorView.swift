//
//  BrushesCollectionView.swift
//  Drawing Board
//
//  Created by Alina Biesiedina on 2022-09-22.
//

import UIKit


class BrushSelectorView: UIView, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    
    // MARK: - Constants
    
    private enum Constants {
        enum ListLayout {
            static let itemsSpacing: CGFloat = 8
            static let contentInsets = UIEdgeInsets(horizontal: 16, vertical: 4)
        }
    }
    
    // MARK: - Section
    
    private enum Section: Int {
        case brushes
    }
    
    // MARK: - Private Properties
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = Constants.ListLayout.itemsSpacing
        layout.sectionInset = Constants.ListLayout.contentInsets
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.allowsMultipleSelection = false
        return collectionView
    }()
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Brush> = {
        let dataSource = UICollectionViewDiffableDataSource<Section, Brush>(collectionView: collectionView) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(
                withType: BrushSelectionCell.self,
                forItemAt: indexPath
            )
            cell.setBrush(item)
            
            return cell
        }
        
        return dataSource
    }()
    
    private let brushes: [Brush]
    private let selectorCallback: ((Brush) -> Void)?
    
    
    // MARK: - Init
    
    init(
        frame: CGRect = .zero,
        brushes: [Brush],
        initiallySelectedBrush: Brush? = nil,
        selectorCallback: ((Brush) -> Void)?
    ) {
        self.brushes = brushes
        self.selectorCallback = selectorCallback
        
        super.init(frame: frame)
        
        setupCollectionView(initiallySelectedBrush: initiallySelectedBrush)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Methods
    
    private func setupCollectionView(initiallySelectedBrush: Brush?) {
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        
        collectionView.register(
            BrushSelectionCell.self,
            forCellWithReuseIdentifier: BrushSelectionCell.reuseIdentifier
        )
        
        embed(collectionView)
        
        setupInitialSnapshot()
        
        if let initiallySelectedBrush = initiallySelectedBrush,
           let initialBrushIndex = dataSource.indexPath(for: initiallySelectedBrush) {
            collectionView.selectItem(at: initialBrushIndex, animated: false, scrollPosition: .bottom)
        }
    }
    
    private func setupInitialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Brush>()
        snapshot.appendSections([.brushes])
        snapshot.appendItems(brushes, toSection: .brushes)
        
        dataSource.apply(snapshot)
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedBrush = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        selectorCallback?(selectedBrush)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSide = collectionView.bounds.height - Constants.ListLayout.contentInsets.vertical
        return CGSize.init(width: itemSide, height: itemSide)
    }
    
}


// MARK: - UIEdgeInsets Helper Extension

private extension UIEdgeInsets {
    var vertical: CGFloat {
        top + bottom
    }
    
    init(horizontal: CGFloat, vertical: CGFloat) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
    
}
