//
//  CardsItemTableViewCell.swift
//  BlackStarShop_V2
//
//  Created by Norik on 11.09.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import UIKit

class CartsItemTableViewCell: UITableViewCell {
    
    typealias CartsItemTableViewCellCall = (CartsItemTableViewCell) -> ()
    
    var minusButtonTicked: CartsItemTableViewCellCall?
    
    //MARK: - UI
    
    lazy var photoImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    lazy var costLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()
    
    lazy var minusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(" - ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(minus), for: .touchUpInside)
        return button
    }()
    
    lazy var quantityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()
    
    lazy var tagLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.textColor = .black
        return label
    }()
    
    lazy var sizeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    lazy var totalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()
    
    //MARK

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        for view in [photoImageView, nameLabel, costLabel, minusButton,
                     quantityLabel, tagLabel, sizeLabel, totalLabel] {
            contentView.addSubview(view)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            photoImageView.widthAnchor.constraint(equalTo: photoImageView.heightAnchor, multiplier: 63/84),
            
            costLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            costLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            costLabel.widthAnchor.constraint(equalToConstant: 70),
            
            nameLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: costLabel.leadingAnchor, constant: -10),
            nameLabel.topAnchor.constraint(equalTo: costLabel.topAnchor),
            
            tagLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            tagLabel.trailingAnchor.constraint(equalTo: costLabel.trailingAnchor),
            tagLabel.widthAnchor.constraint(equalToConstant: 70),
            
            quantityLabel.centerYAnchor.constraint(equalTo: tagLabel.centerYAnchor),
            quantityLabel.trailingAnchor.constraint(equalTo: tagLabel.leadingAnchor, constant: -15),
            
            minusButton.centerYAnchor.constraint(equalTo: quantityLabel.centerYAnchor),
            minusButton.trailingAnchor.constraint(equalTo: quantityLabel.leadingAnchor, constant: -8),
            
            totalLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            totalLabel.trailingAnchor.constraint(equalTo: costLabel.trailingAnchor),
            totalLabel.widthAnchor.constraint(equalTo: costLabel.widthAnchor),
            
            sizeLabel.centerYAnchor.constraint(equalTo: totalLabel.centerYAnchor),
            sizeLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            sizeLabel.trailingAnchor.constraint(equalTo: totalLabel.leadingAnchor, constant: -15)
        ])
    }
    
    //MARK: - Private Methods
    
    @objc private func minus() {
        minusButtonTicked?(self)
    }
    
    //MARK: - Methods
    
    func hideButton() {
        if quantityLabel.text != "1" {
            minusButton.isHidden = false
        } else {
            minusButton.isHidden = true
        }
    }
}
