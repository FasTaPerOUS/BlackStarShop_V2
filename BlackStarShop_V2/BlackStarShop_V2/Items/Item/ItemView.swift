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
        return collectionView
    }()
    
    private var leftButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("<", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont(name: "System Ultra Light", size: 50)
        button.addTarget(self, action: #selector(leftClick), for: .touchUpInside)
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
    
    //MARK: - Init
    
    init(viewController: ItemViewController, colorsCount: Int) {
        self.viewController = viewController
        super.init(frame: .zero)
        backgroundColor = .white
        addSubviews()
        setupConstraints(colorsCount: colorsCount)
        hideColorViews(colorsCount: colorsCount)
        updateMainLabels()
        addDelegateAndDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Methods
    
    @objc private func leftClick() {
        guard let nextIndex = viewController?.decreaseCurrImageIndex() else { return }
        imagesCollectionView.scrollToItem(at: .init(row: nextIndex, section: 0),
                                          at: .centeredHorizontally, animated: true)
        checkAndHideLeftRightButtons(index: nextIndex)
    }
    
    @objc private func rightClick() {
        guard let nextIndex = viewController?.increaseCurrImageIndex() else { return }
        imagesCollectionView.scrollToItem(at: .init(row: nextIndex, section: 0),
                                          at: .centeredHorizontally, animated: true)
        checkAndHideLeftRightButtons(index: nextIndex)
    }
    
    @objc private func colorsClick() {
        viewController?.showColorsController()
    }
    
    @objc private func addItemClick() {
        
    }
    
    private func addSubviews() {
        addSubview(scrollView)
        for view in [leftButton, imagesCollectionView, rightButton, nameLabel, separatorView, leftPriceLabel, rightPriceLabel, leftColorLabel, rightColorButton, addItemToCartButton, descriptionLabel] {
            scrollView.addSubview(view)
        }
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
    
    private func checkAndHideLeftRightButtons(index: Int) {
        guard let quantity = viewController?.model?.images.count else {
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
    
    //MARK: - Methods
    
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
    
    func reloadData() {
        imagesCollectionView.reloadData()
    }

}

extension ItemView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    private func addDelegateAndDataSource() {
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewController?.countImages() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Images for item", for: indexPath) as? ItemCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.imageView.image = viewController?.getImage(index: indexPath.row)
        return cell
    }
}
