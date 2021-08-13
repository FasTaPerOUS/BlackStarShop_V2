//
//  InfoFieldController.swift
//  BlackStarShop_V2
//
//  Created by Norik on 11.08.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import UIKit

protocol InfoFieldCheckProtocol {
    var checker: (() -> Bool)? { get set }
}

class InfoFieldController: UIViewController, InfoFieldCheckProtocol {
    
    //MARK: - Dependencies
    
    var myView: InfoField?
    
    //MARK: - Properties
    
    var labelText = ""
    var textFieldPlaceholder = ""
    var pattern = ""
    var checker: (() -> Bool)?
    
    //MARK: - Init
    
    init(type: InfoFieldType) {
        super.init(nibName: nil, bundle: nil)
        setupPropertiesAndChecker(type: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Private methods
    
    private func setupPropertiesAndChecker(type: InfoFieldType) {
        switch type {
        case .name:
            setup(labelText: "Имя", textFieldPlaceholder: "Введите имя", checker: nameCheck, pattern: "^([а-яА-Я]{1,})?([ ][а-яА-Я]{1,}){0,}$")
        case .email:
            setup(labelText: "Почта", textFieldPlaceholder: "Введите e-mail", checker: emailCheck)
        case .phone:
            setup(labelText: "Телефон", textFieldPlaceholder: "Введите телефон", checker: phoneCheck, pattern: "^(([+][7])|[8])[0-9]{10}$")
        case .city:
            setup(labelText: "Город", textFieldPlaceholder: "Введите город", checker: cityCheck)
        case .street:
            setup(labelText: "Улица", textFieldPlaceholder: "Введите улицу", checker: streetCheck)
        case .house:
            setup(labelText: "Дом", textFieldPlaceholder: "Введите дом", checker: houseCheck, pattern: "^([1-9])([0-9]{0,})$")
        case .building:
            setup(labelText: "Корпус", textFieldPlaceholder: "Введите корпус", checker: buildingCheck)
        case .flat:
            setup(labelText: "Квартира", textFieldPlaceholder: "Введите квартиру", checker: flatCheck)
        case .floor:
            setup(labelText: "Этаж", textFieldPlaceholder: "Введите этаж", checker: floorCheck)
        case .entrance:
            setup(labelText: "Подъезд", textFieldPlaceholder: "Введите подъезд", checker: entranceCheck)
        case .codeOfEntrance:
            setup(labelText: "Код", textFieldPlaceholder: "Введите код", checker: codeOfEntranceCheck)
        }
    }
    
    private func setup(labelText: String, textFieldPlaceholder: String, checker: @escaping (() -> Bool), pattern: String = "") {
        self.labelText = labelText
        self.textFieldPlaceholder = textFieldPlaceholder
        self.checker = checker
        self.pattern = pattern
    }
    
    private func nameCheck() -> Bool {
        return isCorrectUsingReg()
    }
    
    private func emailCheck() -> Bool {
        guard let check = myView?.textField.text?.contains("@") else {
            myView?.selectWrongTextField()
            return false
        }
        if !check {
            myView?.selectWrongTextField()
            return false
        }
        myView?.deselectWrongTextField()
        return true
    }
    
    private func phoneCheck() -> Bool {
        return isCorrectUsingReg()
    }
    
    private func cityCheck() -> Bool {
        return true
    }
    
    private func streetCheck() -> Bool {
        return true
    }
    
    private func houseCheck() -> Bool {
        return isCorrectUsingReg()
    }
    
    private func buildingCheck() -> Bool {
        return true
    }
    
    private func flatCheck() -> Bool {
        return true
    }
    
    private func floorCheck() -> Bool {
        return true
    }
    
    private func entranceCheck() -> Bool {
        return true
    }
    
    private func codeOfEntranceCheck() -> Bool {
        return true
    }
    
    private func textRegCheck() -> Bool {
        guard let check = myView?.textField.text?.matches(pattern) else {
            return false
        }
        if !check { return false }
        return true
    }
    
    private func isCorrectUsingReg() -> Bool {
        if !textRegCheck() {
            myView?.selectWrongTextField()
            return false
        }
        myView?.deselectWrongTextField()
        return true
    }
}

//MARK: - RegularChecker

extension String {
    func matches(_ regex: String) -> Bool {
        return (self.range(of: regex, options: .regularExpression) != nil)
    }
}
