//
//  InfoField.swift
//  BlackStarShop_V2
//
//  Created by Norik on 28.07.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import UIKit

enum InfoFieldType {
    case name
    case email
    case phone
    case city
    case street
    case house
    case building
    case flat
    case floor
    case entrance
    case codeOfEntrance
}

final class InfoField: UIView {
    
    let controller: InfoFieldController?
    
    //MARK: - UI
    
    private let a = UIView()
    let label = UILabel()
    let textField = UITextField()
    
    //MARK: - Init
    
    init(textFieldType: InfoFieldType) {
        controller = InfoFieldController(type: textFieldType)
        super.init(frame: .zero)
        controller?.myView = self
        setup(label: controller?.labelText ?? "", placeholder: controller?.textFieldPlaceholder)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    
    private func setup(label name: String, placeholder text: String?) {
        label.text = name
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemBlue
        textField.placeholder = text
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderWidth = 0
        textField.layer.borderColor = UIColor.systemRed.cgColor
        a.translatesAutoresizingMaskIntoConstraints = false
        a.backgroundColor = .lightGray
        addSubview(a)
        addSubview(label)
        addSubview(textField)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            textField.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: label.trailingAnchor),
            
            a.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 3),
            a.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            a.trailingAnchor.constraint(equalTo: label.trailingAnchor),
            a.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    //MARK: - Methods
    
    func selectWrongTextField() {
        a.backgroundColor = .systemRed
    }
    
    func deselectWrongTextField() {
        a.backgroundColor = .lightGray
    }
}
