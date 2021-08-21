//
//  CategoryTableViewCell.swift
//  BlackStarShop_V2
//
//  Created by Norik on 19.08.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import UIKit

final class CategoryTableViewCell: UITableViewCell {

    lazy var iconImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
//        image.layer.cornerRadius = 10
        return image
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = label.font.withSize(21)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        configureConstraints()
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func addSubviews() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(nameLabel)
    }
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            iconImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 15),
            nameLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor)
        ])
    }
}

public extension UIColor {
    static var mainColor: UIColor {
        return UIColor(displayP3Red: 232/255, green: 231/255, blue: 255/255, alpha: 1)
    }
}
