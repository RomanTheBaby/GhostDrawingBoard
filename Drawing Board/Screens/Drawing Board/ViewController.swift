//
//  ViewController.swift
//  Drawing Board
//
//  Created by Alina Biesiedina on 2022-09-21.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate {
    
    // MARK: - Section
    
    private enum Section: Int {
        case colors
    }
    
    private struct PalleteItem: Identifiable, Hashable {
        var color: UIColor
        var name: String
        var outputDelay: CGFloat = 0
        
        var id: String {
            return name
        }
    }
    
    // MARK: - Constants
    
    private enum Constants {
        enum PaletteView {
            static let height: CGFloat = 50
        }
    }
    
    // MARK: - Private Properties
    
    private var mainImageView = UIImageView()
    private var tempImageView = UIImageView()
    
    private lazy var collectionView: UICollectionView = {
//        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
//        configuration.showsSeparators = false
//        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.allowsMultipleSelection = false
        return collectionView
    }()
    
    private func createLayout() -> UICollectionViewLayout {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalHeight(0.9),
                                                                             heightDimension: .fractionalHeight(1)))
        
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1))
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                   heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//        group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous //orthogonalScrollingBehavior = .paging
        section.interGroupSpacing = 16
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, PalleteItem> = {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, PalleteItem> { cell, indexPath, item in
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = item.name
            
            cell.backgroundColor = item.color
            cell.contentView.backgroundColor = item.color
//            cell.contentConfiguration = contentConfiguration
        }
        
        let dataSource = UICollectionViewDiffableDataSource<Section, PalleteItem>(collectionView: collectionView) { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: item)
        }
        
        return dataSource
    }()
    
    
    // MARK: - Drawing Properties
    
    private var lastPoint = CGPoint.zero
    private var color = UIColor.black
    private var brushWidth: CGFloat = 10.0
    private var opacity: CGFloat = 1.0
    private var swiped = false
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    // MARK: - Setup
    
    private func setupCollectionView() {
        let colorPicketView = UIView()
        colorPicketView.layer.shadowRadius = 10
        colorPicketView.layer.shadowOpacity = 0.8
        colorPicketView.layer.shadowOffset = .init(width: 1, height: 1)
        colorPicketView.layer.shadowColor = UIColor.black.cgColor
        colorPicketView.layer.cornerRadius = Constants.PaletteView.height / 2
        colorPicketView.backgroundColor = .systemBackground
        
        colorPicketView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(colorPicketView)
        
//        NSLayoutConstraint.activate([
//            colorPicketView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
//            colorPicketView.leadingAnchor.constraint(greaterThanOrEqualToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 2),
//            colorPicketView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
//            colorPicketView.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
//            colorPicketView.heightAnchor.constraint(equalToConstant: Constants.PaletteView.height)
//        ])
        
//        NSLayoutConstraint.activate([
//            colorPicketView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
//            colorPicketView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 2),
//            colorPicketView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            colorPicketView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//        ])
        
        collectionView.layer.cornerRadius = Constants.PaletteView.height / 2
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        collectionView.layer.shadowRadius = 10
        collectionView.layer.shadowOpacity = 0.8
        collectionView.layer.shadowOffset = .init(width: 1, height: 1)
        collectionView.layer.shadowColor = UIColor.black.cgColor
        collectionView.layer.cornerRadius = Constants.PaletteView.height / 2
//        collectionView.backgroundColor = .systemBackground
        collectionView.backgroundColor = .brown
        
//        NSLayoutConstraint.activate([
//            collectionView.leadingAnchor.constraint(equalTo: colorPicketView.leadingAnchor),
//            collectionView.trailingAnchor.constraint(equalTo: colorPicketView.trailingAnchor),
//            collectionView.bottomAnchor.constraint(equalTo: colorPicketView.bottomAnchor),
//            collectionView.topAnchor.constraint(equalTo: colorPicketView.topAnchor),
//        ])
        
//        let secon2 = collectionView.widthAnchor.constraint(greaterThanOrEqualToConstant: 50)
//        secon2.priority = .init(999)
//
//        let secon3 = collectionView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 2)
//        secon3.priority = .init(999)
        
        NSLayoutConstraint.activate([
            collectionView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            collectionView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 2),
            collectionView.widthAnchor.constraint(greaterThanOrEqualToConstant: Constants.PaletteView.height),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
        ])
        
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        
        setupInitialSnapshot()
        
    }
    
    private func setupInitialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, PalleteItem>()
        snapshot.appendSections([.colors])
        snapshot.appendItems([
            .init(color: .red, name: "red"),
            .init(color: .green, name: "blue"),
            .init(color: .blue, name: "green"),
            .init(color: .yellow, name: "yellow"),
        ], toSection: .colors)
        
        dataSource.apply(snapshot)
        
        collectionView.invalidateIntrinsicContentSize()
    }
    
    private func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
      // 1
      UIGraphicsBeginImageContext(view.frame.size)
      guard let context = UIGraphicsGetCurrentContext() else {
        return
      }
        
      tempImageView.image?.draw(in: view.bounds)
        
      // 2
      context.move(to: fromPoint)
      context.addLine(to: toPoint)
      
      // 3
      context.setLineCap(.round)
      context.setBlendMode(.normal)
      context.setLineWidth(brushWidth)
      context.setStrokeColor(color.cgColor)
      
      // 4
      context.strokePath()
      
      // 5
      tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
      tempImageView.alpha = opacity
      UIGraphicsEndImageContext()
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print("Did Select: ", indexPath)
        
        guard let selectedColor = dataSource.itemIdentifier(for: indexPath)?.color else {
            return
        }
        
        color = selectedColor
    }
    
    // MARK: - UIResponder
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        swiped = false
        lastPoint = touch.location(in: view)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
      guard let touch = touches.first else {
        return
      }

      // 6
      swiped = true
      let currentPoint = touch.location(in: view)
      drawLine(from: lastPoint, to: currentPoint)
        
      // 7
      lastPoint = currentPoint
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
      if !swiped {
        // draw a single point
        drawLine(from: lastPoint, to: lastPoint)
      }
        
      // Merge tempImageView into mainImageView
      UIGraphicsBeginImageContext(mainImageView.frame.size)
      mainImageView.image?.draw(in: view.bounds, blendMode: .normal, alpha: 1.0)
      tempImageView.image?.draw(in: view.bounds, blendMode: .normal, alpha: opacity)
      mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
        
      tempImageView.image = nil
    }

}
