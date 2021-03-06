//
//  ItemsCollectionViewCell.swift
//  BlackStarShop_V2
//
//  Created by Norik on 27.08.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import UIKit

final class ItemsCollectionViewCell: UICollectionViewCell {
    
    //MARK: - UI
    
    lazy var nameLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    
    lazy var photoImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var curPriceLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    lazy var oldPriceLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        return label
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Methods
    
    private func addSubviews() {
        for view in [nameLabel, photoImageView, oldPriceLabel, curPriceLabel] {
            contentView.addSubview(view)
        }
    }
    
    private func setupConstraints() {
        let labelsHeight: CGFloat = 17
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            
            photoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            photoImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            photoImageView.heightAnchor.constraint(equalTo: photoImageView.widthAnchor, multiplier: 84/63),
            
            curPriceLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 10),
            curPriceLabel.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor),
            curPriceLabel.heightAnchor.constraint(equalTo: nameLabel.heightAnchor),
            
            oldPriceLabel.trailingAnchor.constraint(equalTo: curPriceLabel.leadingAnchor, constant: -5),
            oldPriceLabel.heightAnchor.constraint(equalToConstant: labelsHeight - 1),
            oldPriceLabel.centerYAnchor.constraint(equalTo: curPriceLabel.centerYAnchor)
        ])
    }
}
