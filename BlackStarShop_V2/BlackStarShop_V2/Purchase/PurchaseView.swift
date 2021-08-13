//
//  PurchaseView.swift
//  BlackStarShop_V2
//
//  Created by Norik on 28.07.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import UIKit

final class PurchaseView: UIView {
    
    weak var viewController: PurchaseViewController?
    
    //MARK: - UI
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    lazy var nameField = InfoField(textFieldType: .name)
    lazy var emailField = InfoField(textFieldType: .email)
    lazy var phoneField = InfoField(textFieldType: .phone)
    lazy var cityField = InfoField(textFieldType: .city)
    lazy var streetField = InfoField(textFieldType: .street)
    lazy var houseField = InfoField(textFieldType: .house)
    lazy var buildingField = InfoField(textFieldType: .building)
    lazy var flatField = InfoField(textFieldType: .flat)
    lazy var floorField = InfoField(textFieldType: .floor)
    lazy var entranceField = InfoField(textFieldType: .entrance)
    lazy var codeOfEntranceField = InfoField(textFieldType: .codeOfEntrance)
    
    private lazy var personalInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Контакты"
        label.textColor = .systemBlue
        label.font = label.font.withSize(22)
        return label
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Адрес"
        label.textColor = .systemBlue
        label.font = label.font.withSize(22)
        return label
    }()
    
    private lazy var personalInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addBackground(color: .white, cornerRadius: 10)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var addressStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addBackground(color: .white, cornerRadius: 10)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var cityPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(cityEditingDidEnd))
        toolBar.setItems([UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), doneButton], animated: true)
        cityField.textField.inputAccessoryView = toolBar
        return pickerView
    }()
    
    private lazy var confirmPurchaseButton: UIButton = {
        let button = UIButton()
        button.setTitle(" Подтвердить заказ ", for: .normal)
        button.setTitleColor(.white, for: .highlighted)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(confirmPurchase), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Init
    
    init(viewController: PurchaseViewController) {
        super.init(frame: .zero)
        self.backgroundColor = UIColor(displayP3Red: 232/255, green: 231/255, blue: 255/255, alpha: 1)
        self.viewController = viewController
        cityPickerView.delegate = viewController
        cityPickerView.dataSource = viewController
        setNavigationBarTitle(str: "Оформление заказа")
        addSubviews()
        addTargets()
        textInit()
        setupConstraints()
        configuratePersonalStackView()
        configurateAddressStackView()
        configurateCityField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setNavigationBarTitle(str: String) {
        viewController?.navigationController?.navigationItem.title = str
    }
    
    private func addSubviews() {
        addSubview(scrollView)
        for i in [personalInfoStackView, personalInfoLabel, addressStackView, addressLabel, confirmPurchaseButton] {
            scrollView.addSubview(i)
        }
    }
    
    private func addTargets() {
        nameField.textField.addTarget(self, action: #selector(nameEditingDidEnd), for: .primaryActionTriggered)
        emailField.textField.addTarget(self, action: #selector(emailEditingDidEnd), for: .primaryActionTriggered)
        phoneField.textField.addTarget(self, action: #selector(phoneEditingDidEnd), for: .primaryActionTriggered)
        streetField.textField.addTarget(self, action: #selector(streetEditingDidEnd), for: .primaryActionTriggered)
        houseField.textField.addTarget(self, action: #selector(houseEditingDidEnd), for: .primaryActionTriggered)
        buildingField.textField.addTarget(self, action: #selector(buildingEditingDidEnd), for: .primaryActionTriggered)
        flatField.textField.addTarget(self, action: #selector(flatEditingDidEnd), for: .primaryActionTriggered)
        floorField.textField.addTarget(self, action: #selector(floorEditingDidEnd), for: .primaryActionTriggered)
        entranceField.textField.addTarget(self, action: #selector(entranceEditingDidEnd), for: .primaryActionTriggered)
        codeOfEntranceField.textField.addTarget(self, action: #selector(codeOfEntranceEditingDidEnd), for: .primaryActionTriggered)
    }
    
    private func textInit() {
        nameField.textField.text = viewController?.purchaseInfo[0]
        emailField.textField.text = viewController?.purchaseInfo[1]
        phoneField.textField.text = viewController?.purchaseInfo[2]
        cityField.textField.text = viewController?.purchaseInfo[3]
        streetField.textField.text = viewController?.purchaseInfo[4]
        houseField.textField.text = viewController?.purchaseInfo[5]
        buildingField.textField.text = viewController?.purchaseInfo[6]
        flatField.textField.text = viewController?.purchaseInfo[7]
        floorField.textField.text = viewController?.purchaseInfo[8]
        entranceField.textField.text = viewController?.purchaseInfo[9]
        codeOfEntranceField.textField.text = viewController?.purchaseInfo[10]
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            personalInfoLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            personalInfoLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 30),
            
            personalInfoStackView.topAnchor.constraint(equalTo: personalInfoLabel.bottomAnchor, constant: 20),
            personalInfoStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            personalInfoStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            personalInfoStackView.heightAnchor.constraint(equalToConstant: 230),
            
            addressLabel.topAnchor.constraint(equalTo: personalInfoStackView.bottomAnchor, constant: 40),
            addressLabel.leadingAnchor.constraint(equalTo: personalInfoStackView.leadingAnchor, constant: 10),
            
            addressStackView.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 20),
            addressStackView.leadingAnchor.constraint(equalTo: personalInfoStackView.leadingAnchor),
            addressStackView.trailingAnchor.constraint(equalTo: personalInfoStackView.trailingAnchor),
            addressStackView.heightAnchor.constraint(equalToConstant: 300),
            
            confirmPurchaseButton.topAnchor.constraint(equalTo: addressStackView.bottomAnchor, constant: 30),
            confirmPurchaseButton.trailingAnchor.constraint(equalTo: addressStackView.trailingAnchor),
            confirmPurchaseButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 20)
        ])
    }
    
    private func configuratePersonalStackView() {
        for i in [nameField, emailField, phoneField] {
            personalInfoStackView.addArrangedSubview(i)
        }
    }
    
    private func configurateAddressStackView() {
        let array = [cityField, streetField, houseField, buildingField, flatField,
                     floorField, entranceField, codeOfEntranceField]
        for i in 1...array.count / 2 {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackView.addArrangedSubview(array[i * 2 - 2])
            stackView.addArrangedSubview(array[i * 2 - 1])
            if i == array.count / 2 && array.count % 2 == 1 {
                print(array.count / 2 - 1, array.count % 2)
                stackView.addArrangedSubview(array.last ?? UIView())
            }
            addressStackView.addArrangedSubview(stackView)
        }
    }
    
    private func configurateCityField() {
        cityField.textField.inputView = cityPickerView
        cityField.textField.text = "Москва"
    }
    
    private func nextField(_ field: InfoField) {
        guard let a = field.textField.text else {
            field.becomeFirstResponder()
            return
        }
        if a != "" {
            endEditing(true)
        } else {
            field.textField.becomeFirstResponder()
        }
    }
    
    @objc private func nameEditingDidEnd() {
        viewController?.updateUserInfo(str: nameField.textField.text ?? "", key:
            PurchaseInfoKeys.name)
        nameField.textField.resignFirstResponder()
        nextField(emailField)
    }
    @objc private func emailEditingDidEnd() {
        viewController?.updateUserInfo(str: emailField.textField.text ?? "", key:
        PurchaseInfoKeys.email)
        emailField.textField.resignFirstResponder()
        nextField(phoneField)
    }
    @objc private func phoneEditingDidEnd() {
        viewController?.updateUserInfo(str: phoneField.textField.text ?? "", key:
        PurchaseInfoKeys.phone)
        phoneField.textField.resignFirstResponder()
        nextField(cityField)
    }
    @objc private func cityEditingDidEnd() {
        cityField.textField.resignFirstResponder()
        nextField(streetField)
    }
    @objc private func streetEditingDidEnd() {
        viewController?.updateUserInfo(str: streetField.textField.text ?? "", key:
        PurchaseInfoKeys.street)
        streetField.textField.resignFirstResponder()
        nextField(houseField)
    }
    @objc private func houseEditingDidEnd() {
        viewController?.updateUserInfo(str: houseField.textField.text ?? "", key:
        PurchaseInfoKeys.house)
        houseField.textField.resignFirstResponder()
        nextField(buildingField)
    }
    @objc private func buildingEditingDidEnd() {
        viewController?.updateUserInfo(str: buildingField.textField.text ?? "", key:
        PurchaseInfoKeys.building)
        buildingField.textField.resignFirstResponder()
        nextField(flatField)
    }
    @objc private func flatEditingDidEnd() {
        viewController?.updateUserInfo(str: flatField.textField.text ?? "", key:
        PurchaseInfoKeys.flat)
        flatField.textField.resignFirstResponder()
        nextField(floorField)
    }
    @objc private func floorEditingDidEnd() {
        viewController?.updateUserInfo(str: floorField.textField.text ?? "", key:
        PurchaseInfoKeys.floor)
        floorField.textField.resignFirstResponder()
        nextField(entranceField)
    }
    @objc private func entranceEditingDidEnd() {
        viewController?.updateUserInfo(str: entranceField.textField.text ?? "", key:
        PurchaseInfoKeys.entrance)
        entranceField.textField.resignFirstResponder()
        nextField(codeOfEntranceField)
    }
    @objc private func codeOfEntranceEditingDidEnd() {
        viewController?.updateUserInfo(str: codeOfEntranceField.textField.text ?? "", key:
        PurchaseInfoKeys.codeOfEntrance)
        endEditing(true)
    }
    
    @objc private func confirmPurchase() {
        viewController?.showAlert()
    }
    
    func updateCityTextField(str: String) {
        cityField.textField.text = str
    }
}

extension UIStackView {

    func addBackground(color: UIColor, cornerRadius: CGFloat? = 0) {
        let subview = UIView(frame: bounds)
        subview.backgroundColor = color
        subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        subview.layer.cornerRadius = cornerRadius ?? 0
        insertSubview(subview, at: 0)
    }

}
