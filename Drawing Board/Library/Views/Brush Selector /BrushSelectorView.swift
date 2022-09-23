//
//  BrushesCollectionView.swift
//  Drawing Board
//
//  Created by Alina Biesiedina on 2022-09-22.
//

import UIKit


class BrushSelectorView: UIView, UICollectionViewDelegate {
    
    // MARK: - Section
    
    private enum Section: Int {
        case brushes
    }
    
    // MARK: - Private Properties
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.allowsMultipleSelection = false
        return collectionView
    }()
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Brush> = {
//        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Brush> { cell, indexPath, item in
//            cell.backgroundColor = item.color
//            cell.contentView.backgroundColor = item.color
//        }
        
//        let cellRegistration = UICollectionView.CellRegistration<BrushSelectionCell, Brush> { cell, indexPath, item in
//            cell.item = item
//        }
        
        let dataSource = UICollectionViewDiffableDataSource<Section, Brush>(collectionView: collectionView) { collectionView, indexPath, item in
//            return collectionView.dequeueConfiguredReusableCell(
//                using: cellRegistration,
//                for: indexPath,
//                item: item)
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
        collectionView.register(cell: BrushSelectionCell.self)
        
        embed(collectionView)
        
        setupInitialSnapshot()
        
        if let initiallySelectedBrush = initiallySelectedBrush,
           let initialBrushIndex = dataSource.indexPath(for: initiallySelectedBrush) {
            collectionView.selectItem(at: initialBrushIndex, animated: false, scrollPosition: .bottom)
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalHeight(1),
                                                                             heightDimension: .fractionalHeight(1)))
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        group.interItemSpacing = .fixed(8)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 16
        
        return UICollectionViewCompositionalLayout(section: section)
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
    
}
