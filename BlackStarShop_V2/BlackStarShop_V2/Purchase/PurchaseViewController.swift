//
//  PurchaseViewController.swift
//  BlackStarShop_V2
//
//  Created by Norik on 28.07.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import UIKit

protocol PurchaseInfoChecker {
    func getWrongInfo() -> [String]
}

final class PurchaseViewController: UIViewController, PurchaseInfoChecker {
    
    // MARK: - Dependencies
    
    var myView: PurchaseView?
    
    // MARK: - Properties
    
    private let purchaseModel = PurchaseInfo()
    var purchaseInfo = PurchaseInfo().takeUserInfo()
    let cities = ["Москва", "Санкт-Петербург", "Краснодар"]
    
    // MARK: - Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Оформление"
        myView = PurchaseView(viewController: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func loadView() {
        super.loadView()
        udpateNavigationBarAndTabBarBackgroundColor(color: .mainColor)
        view = myView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        udpateNavigationBarAndTabBarBackgroundColor(color: .mainColor)
    }
    
    // MARK: - Methods
    
    func updateUserInfo(str: String, key: PurchaseInfoKeys) {
        purchaseModel.updateUserInfo(str: str, key: key)
    }
    
    func showAlert() {
        let wrongFields = getWrongInfo()
        var title = ""
        var message = ""
        if wrongFields.count != 0 {
            title = "Неправильно введены поля"
            message = "Неверный формат в следующих полях: "
            for el in wrongFields {
                message += el + ", "
            }
            message = String(message.dropLast(2))
        } else {
            title = "Сбер топ!"
            message = "Ставим лайк в дневник, где лайк - пятерка по пятибальной системе"
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func getWrongInfo() -> [String] {
        let arr = [myView?.nameField,
                   myView?.emailField,
                   myView?.phoneField,
                   myView?.cityField,
                   myView?.streetField,
                   myView?.houseField,
                   myView?.buildingField,
                   myView?.flatField,
                   myView?.floorField,
                   myView?.entranceField,
                   myView?.codeOfEntranceField]
        var wrongFields = [String]()
        for el in arr {
            guard let check = el?.controller?.checker else {
                return wrongFields
            }
            if !check() { wrongFields.append((el?.label.text?.lowercased()) ?? "") }
        }
        return wrongFields
    }

}

// MARK: - Picker delegate, datasource

extension PurchaseViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cities[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        myView?.updateCityTextField(str: cities[row])
        purchaseModel.updateUserInfo(str: cities[row], key: PurchaseInfoKeys.city)
    }
}
	
