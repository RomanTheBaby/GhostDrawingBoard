//
//  BrushesCollectionView.swift
//  Drawing Board
//
//  Created by Alina Biesiedina on 2022-09-22.
//

import UIKit


class InstrumentsView: UIView, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    enum ActionType {
        case changedBrush(Brush)
        case clear
        case undo
    }
    
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
    
    private lazy var undoButton = {
        let undoButton = UIButton()
        undoButton.setImage(UIImage(systemName: "arrow.turn.up.left"), for: .normal)
        undoButton.addTarget(self, action: #selector(handleUndoAction), for: .touchUpInside)
        
        return undoButton
    }()
    
    private lazy var clearButton = {
        let clearButton = UIButton()
        clearButton.setImage(UIImage(systemName: "trash"), for: .normal)
        clearButton.addTarget(self, action: #selector(handleClearAction), for: .touchUpInside)
        
        return clearButton
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [undoButton, clearButton])
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        return stackView
    }()
    
    private let brushes: [Brush]
    private let actionHandler: ((ActionType) -> Void)?
    
    
    // MARK: - Init
    
    init(
        frame: CGRect = .zero,
        brushes: [Brush],
        initiallySelectedBrush: Brush? = nil,
        actionHandler: ((ActionType) -> Void)? = nil
    ) {
        self.brushes = brushes
        self.actionHandler = actionHandler
        
        super.init(frame: frame)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        [
            stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            stackView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.3),
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ].activate()
        
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
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionView)
        [
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 8),
        ].activate()
        
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
    
    
    // MARK: - Actions Handling
    
    @objc private func handleClearAction() {
        actionHandler?(.clear)
    }
    
    @objc private func handleUndoAction() {
        actionHandler?(.undo)
    }
    
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedBrush = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        actionHandler?(.changedBrush(selectedBrush))
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
