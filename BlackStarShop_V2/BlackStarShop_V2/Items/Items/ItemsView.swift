//
//  ItemsView.swift
//  BlackStarShop_V2
//
//  Created by Norik on 27.08.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import UIKit

final class ItemsView: UIView {

    //MARK: - Dependencies
    
    weak var viewController: ItemsViewController?

    //MARK: - UI
    
    private lazy var itemsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let w = UIScreen.main.bounds.width / 2
        let leading: CGFloat = 5
        let z = 5 + 17 + 10 + (w - leading * 2 - 10) * 84/63 + 10 + 17 + 5
        layout.itemSize = CGSize(width: w - 10, height: z)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 1, left: 5, bottom: 1, right: 5)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alpha = 0
        collectionView.register(ItemsCollectionViewCell.self, forCellWithReuseIdentifier: "Item for items")
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    private lazy var notifyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0
        label.numberOfLines = 0
        label.text = "К сожалению, это пустой раздел.\nНажмите на кнопку если хотите увидеть все товары категории.\nЭто может занять некоторое время."
        label.textColor = .black
        return label
    }()
    
    private lazy var showCollectionViewButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        button.setTitle("Все товары", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(showCollectionView), for: .touchUpInside)
        return button
    }()
    
    init(viewController: ItemsViewController) {
        self.viewController = viewController
        super.init(frame: .zero)
        backgroundColor = .white
        addDelegateAndDataSource()
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Methods
    
    @objc private func showCollectionView() {
        viewController?.loadAllItems()
        UIView.animate(withDuration: 0.3) {
            self.notifyLabel.alpha = 0
            self.showCollectionViewButton.alpha = 0
        }
        UIView.animate(withDuration: 0.3) {
            self.itemsCollectionView.alpha = 1
        }
    }
    
    private func addSubviews() {
        for view in [itemsCollectionView, notifyLabel, showCollectionViewButton] {
            addSubview(view)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            itemsCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            itemsCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            itemsCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            itemsCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            
            notifyLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            notifyLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            notifyLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 25),
            
            showCollectionViewButton.centerXAnchor.constraint(equalTo: notifyLabel.centerXAnchor),
            showCollectionViewButton.topAnchor.constraint(equalTo: notifyLabel.bottomAnchor, constant: 10)
        ])
    }
    
    //MARK: - Methods
    
    func configurateView() {
        guard let checker = viewController?.itemsIsEmpty() else {
            return
        }
        if checker {
            notifyLabel.alpha = 1
            showCollectionViewButton.alpha = 1
        } else {
            itemsCollectionView.alpha = 1
        }
    }
    
    func reloadItems(indexPaths: [IndexPath]) {
        itemsCollectionView.reloadItems(at: indexPaths)
    }
    
    func reloadData() {
        itemsCollectionView.reloadData()
    }
}

//MARK: - UICollectionView Delegate, DataSource, DataSourcePrefetching

extension ItemsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    
    private func cleanCell(cell: ItemsCollectionViewCell) {
        cell.nameLabel.text = nil
        cell.imageView.image = nil
        cell.oldPriceLabel.attributedText = nil
        cell.curPriceLabel.text = nil
    }
    
    private func addDelegateAndDataSource() {
        itemsCollectionView.delegate = self
        itemsCollectionView.dataSource = self
        itemsCollectionView.prefetchDataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewController?.countItems() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Item for items", for: indexPath) as? ItemsCollectionViewCell else { return UICollectionViewCell() }
        cleanCell(cell: cell)
        cell.nameLabel.text = viewController?.getName(index: indexPath.row)
        cell.oldPriceLabel.attributedText = viewController?.getOldPrice(index: indexPath.row)
        cell.curPriceLabel.text = (viewController?.getCurPrice(index: indexPath.row) ?? "") + "₽"
        viewController?.getImage(indexPath: indexPath, completion: { (image) in
            DispatchQueue.main.async {
                cell.imageView.image = image
            }
        })
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewController?.goToNextController(index: indexPath.row)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            viewController?.getImage(indexPath: indexPath, completion: nil)
        }
    }
}
