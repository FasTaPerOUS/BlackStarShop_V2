//
//  ItemView.swift
//  BlackStarShop_V2
//
//  Created by Norik on 01.09.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import UIKit

final class ItemView: UIView {
    
    //MARK: - Dependencies
    
    weak var viewController: ItemViewController?
    
    //MARK: - UI
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var imagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let w = UIScreen.main.bounds.width
        layout.itemSize = .init(width: w - 2 * w / 6 - 6, height: w / 6 * 5.5)
        layout.sectionInset = .init(top: 0, left: 3, bottom: 0, right: -3)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: "Images for item")
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var swipeAreaGestureRecogniserView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var leftButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("<", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont(name: "System Ultra Light", size: 50)
        button.addTarget(self, action: #selector(leftClick), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private var rightButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(">", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont(name: "System Ultra Light", size: 50)
        button.addTarget(self, action: #selector(rightClick), for: .touchUpInside)
        return button
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Название"
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont(name: "System Semibold", size: 21)
        return label
    }()
    
    private var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    private var leftPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Стоимость:"
        label.textColor = .black
        return label
    }()
    
    private var rightPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    private var leftColorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Текущий цвет:"
        label.textColor = .black
        return label
    }()
    
    private var rightColorButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Текуший цвет", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(colorsClick), for: .touchUpInside)
        return button
    }()
    
    private var addItemToCartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("  Добавить в корзину  ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(addItemClick), for: .touchUpInside)
        button.layer.cornerRadius = 17
        return button
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Описания"
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var swipeLeftGestureRecogniser: UISwipeGestureRecognizer = {
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
        gesture.direction = .left
        return gesture
    }()
    
    private lazy var swipeRightGestureRecogniser: UISwipeGestureRecognizer = {
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
        gesture.direction = .right
        return gesture
    }()
    
    //MARK: - Init
    
    init(viewController: ItemViewController, colorsCount: Int) {
        self.viewController = viewController
        super.init(frame: .zero)
        backgroundColor = .white
        addSubviews()
        addSwipeGestures()
        setupConstraints(colorsCount: colorsCount)
        hideColorViews(colorsCount: colorsCount)
        updateMainLabels()
        updatePriceLabel()
        addDelegateAndDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Methods
    
    @objc private func swipe(swipeGestureRecogniser: UISwipeGestureRecognizer) {
        let nextIndex: Int
        switch swipeGestureRecogniser.direction {
        case .left:
            if viewController?.currImageIndex == (viewController?.countImages() ?? 0) - 1 {
                return
            }
            nextIndex = viewController?.increaseCurrImageIndex() ?? 0
        case .right:
            if viewController?.currImageIndex == 0 {
                return
            }
            nextIndex = viewController?.decreaseCurrImageIndex() ?? 0
        default:
            return
        }
        scrollTo(index: nextIndex, animated: true)
        checkAndHideLeftRightButtons(index: nextIndex)
    }
    
    @objc private func leftClick() {
        guard let nextIndex = viewController?.decreaseCurrImageIndex() else { return }
        scrollTo(index: nextIndex, animated: true)
        checkAndHideLeftRightButtons(index: nextIndex)
    }
    
    @objc private func rightClick() {
        guard let nextIndex = viewController?.increaseCurrImageIndex() else { return }
        scrollTo(index: nextIndex, animated: true)
        checkAndHideLeftRightButtons(index: nextIndex)
    }
    
    @objc private func colorsClick() {
        viewController?.getColorArrayForNextController()
    }
    
    @objc private func addItemClick() {
        viewController?.getSizeArrayForNextController()
    }
    
    private func addSubviews() {
        addSubview(scrollView)
        for view in [leftButton, imagesCollectionView, swipeAreaGestureRecogniserView, rightButton, nameLabel, separatorView, leftPriceLabel, rightPriceLabel, leftColorLabel, rightColorButton, addItemToCartButton, descriptionLabel] {
            scrollView.addSubview(view)
        }
    }
    
    private func addSwipeGestures() {
        swipeAreaGestureRecogniserView.addGestureRecognizer(swipeLeftGestureRecogniser)
        swipeAreaGestureRecogniserView.addGestureRecognizer(swipeRightGestureRecogniser)
    }
    
    private func setupConstraints(colorsCount: Int) {
        let addItemButtonsTopAnchor: NSLayoutConstraint
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            leftButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 6),
            leftButton.heightAnchor.constraint(equalTo: leftButton.widthAnchor, multiplier: 5.5),
            leftButton.topAnchor.constraint(equalTo: scrollView.topAnchor),
            leftButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            
            rightButton.widthAnchor.constraint(equalTo: leftButton.widthAnchor),
            rightButton.heightAnchor.constraint(equalTo: leftButton.heightAnchor),
            rightButton.topAnchor.constraint(equalTo: leftButton.topAnchor),
            rightButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            
            imagesCollectionView.centerYAnchor.constraint(equalTo: rightButton.centerYAnchor),
            imagesCollectionView.heightAnchor.constraint(equalTo: rightButton.heightAnchor),
            imagesCollectionView.leadingAnchor.constraint(equalTo: leftButton.trailingAnchor),
            imagesCollectionView.trailingAnchor.constraint(equalTo: rightButton.leadingAnchor),
            
            swipeAreaGestureRecogniserView.leadingAnchor.constraint(equalTo: imagesCollectionView.leadingAnchor),
            swipeAreaGestureRecogniserView.trailingAnchor.constraint(equalTo: imagesCollectionView.trailingAnchor),
            swipeAreaGestureRecogniserView.topAnchor.constraint(equalTo: imagesCollectionView.topAnchor),
            swipeAreaGestureRecogniserView.bottomAnchor.constraint(equalTo: imagesCollectionView.bottomAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: imagesCollectionView.bottomAnchor, constant: 10),
            nameLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            separatorView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3),
            separatorView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            separatorView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            leftPriceLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 8),
            leftPriceLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            rightPriceLabel.centerYAnchor.constraint(equalTo: leftPriceLabel.centerYAnchor),
            rightPriceLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),

            addItemToCartButton.centerXAnchor.constraint(equalTo: separatorView.centerXAnchor),
            addItemToCartButton.heightAnchor.constraint(equalToConstant: 35),
            
            descriptionLabel.topAnchor.constraint(equalTo: addItemToCartButton.bottomAnchor, constant: 20),
            descriptionLabel.centerXAnchor.constraint(equalTo: separatorView.centerXAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: leftPriceLabel.leadingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -5)
        ])
        
        if colorsCount > 1 {
            NSLayoutConstraint.activate([
                leftColorLabel.topAnchor.constraint(equalTo: leftPriceLabel.bottomAnchor, constant: 8),
                leftColorLabel.leadingAnchor.constraint(equalTo: leftPriceLabel.leadingAnchor),
                
                rightColorButton.trailingAnchor.constraint(equalTo: rightPriceLabel.trailingAnchor),
                rightColorButton.centerYAnchor.constraint(equalTo: leftColorLabel.centerYAnchor)
            ])
            addItemButtonsTopAnchor = NSLayoutConstraint(item: addItemToCartButton, attribute: .top, relatedBy: .equal, toItem: separatorView, attribute: .bottom, multiplier: 1, constant: 80)
        } else {
            addItemButtonsTopAnchor = NSLayoutConstraint(item: addItemToCartButton, attribute: .top, relatedBy: .equal, toItem: separatorView, attribute: .bottom, multiplier: 1, constant: 80 - 27 - 15)
        }
        addItemButtonsTopAnchor.isActive = true
    }
    
    private func hideColorViews(colorsCount: Int) {
        if colorsCount < 2 {
            leftColorLabel.isHidden = true
            rightColorButton.isHidden = true
        } else {
            updateColorsButtonTitle()
        }
    }
    
    private func updateMainLabels() {
        nameLabel.text = viewController?.getName()
        descriptionLabel.text = viewController?.getDescription()
    }
    
    
    //MARK: - Methods
    
    func checkAndHideLeftRightButtons(index: Int) {
        guard let quantity = viewController?.countImages() else {
            return
        }
        if index == 0 {
            leftButton.isHidden = true
            rightButton.isHidden = false
        } else {
            if index == quantity - 1 {
                rightButton.isHidden = true
                leftButton.isHidden = false
            } else {
                rightButton.isHidden = false
                leftButton.isHidden = false
            }
        }
    }
    
    func configurateLeftRightButtons() {
        leftButton.isHidden = true
        guard let quantity = viewController?.countImages() else {
            return
        }
        if quantity < 2 {
            rightButton.isHidden = true
        }
    }
    
    func updateColorsButtonTitle() {
        rightColorButton.setTitle(viewController?.getCurColor(), for: .normal)
    }
    
    func reloadItems(indexPaths: [IndexPath]) {
        imagesCollectionView.reloadItems(at: indexPaths)
    }
    
    func reloadData() {
        imagesCollectionView.reloadData()
    }
    
    func updatePriceLabel() {
        rightPriceLabel.text = viewController?.getPrice()
    }
    
    func scrollTo(index: Int, animated: Bool) {
        imagesCollectionView.scrollToItem(at: .init(row: index, section: 0), at: .centeredHorizontally, animated: animated)
    }

    func hideAddButton() {
        addItemToCartButton.isHidden = true
    }
}

//MARK: - UICollectionVIew Delegate, DataSource

extension ItemView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    
    private func cleanCell(cell: ItemCollectionViewCell) {
        cell.photoImageView.image = nil
    }
    
    private func addDelegateAndDataSource() {
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        imagesCollectionView.prefetchDataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewController?.countImages() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Images for item", for: indexPath) as? ItemCollectionViewCell else { return UICollectionViewCell() }
        cleanCell(cell: cell)
        viewController?.getImage(indexPath: indexPath, completion: { (image) in
            DispatchQueue.main.async {
                cell.photoImageView.image = image
            }
        })
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            viewController?.getImage(indexPath: indexPath, completion: nil)
        }
    }
}
