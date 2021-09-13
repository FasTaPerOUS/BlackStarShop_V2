//
//  CartView.swift
//  BlackStarShop_V2
//
//  Created by Norik on 10.09.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import UIKit

final class CartView: UIView {
    
    //MARK: - Dependencies
    
    weak var viewController: CartViewController?
    
    //MARK: - UI
    
    private lazy var itemsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CartsItemTableViewCell.self, forCellReuseIdentifier: "Item for cart")
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private lazy var removeAllButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Очистить корзину", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(removeAll), for: .touchUpInside)
        return button
    }()
    
    private lazy var costLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    private lazy var discountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    private lazy var totalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    private lazy var checkoutButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(" Оформить заказ ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(checkout), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Init
    
    init(viewController: CartViewController) {
        self.viewController = viewController
        super.init(frame: .zero)
        addSubviews()
        setupConstraints()
        addDelegateAndDataSource()
        updateLabelsText()
        backgroundColor = .mainColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Methods
    
    @objc private func removeAll() {
        viewController?.removeAll()
    }
    
    @objc private func checkout() {
        viewController?.goToPurchaseController()
    }
    
    private func addSubviews() {
        for view in [removeAllButton, itemsTableView, costLabel,
                     discountLabel, totalLabel, checkoutButton] {
            addSubview(view)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            removeAllButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            removeAllButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            removeAllButton.heightAnchor.constraint(equalToConstant: 28),
            
            checkoutButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
            checkoutButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -15),
            checkoutButton.heightAnchor.constraint(equalToConstant: 30),
            
            discountLabel.bottomAnchor.constraint(equalTo: checkoutButton.topAnchor, constant: -7),
            discountLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            totalLabel.centerYAnchor.constraint(equalTo: checkoutButton.centerYAnchor),
            totalLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            costLabel.bottomAnchor.constraint(equalTo: discountLabel.bottomAnchor),
            costLabel.leadingAnchor.constraint(equalTo: totalLabel.leadingAnchor),
            
            itemsTableView.topAnchor.constraint(equalTo: removeAllButton.bottomAnchor, constant: 5),
            itemsTableView.bottomAnchor.constraint(equalTo: discountLabel.topAnchor, constant: -10),
            itemsTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            itemsTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    //MARK: - Methods
    
    func updateLabelsText() {
        costLabel.text = "Стоимость: \(viewController?.getCostForMainView() ?? "0")₽"
        discountLabel.text = "Скидка: \(viewController?.getDiscountForMainView() ?? "0")₽"
        totalLabel.text = "Итого: \(viewController?.getTotalForMainView() ?? "0")₽"
    }
    
    func reloadItems(indexPaths: [IndexPath]) {
        itemsTableView.reloadRows(at: indexPaths, with: .none)
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.itemsTableView.reloadData()
        }
        
    }
    
}

extension CartView: UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching {
    
    private func addDelegateAndDataSource() {
        itemsTableView.delegate = self
        itemsTableView.dataSource = self
    }
    
    private func cleanCell(cell: CartsItemTableViewCell) {
        cell.photoImageView.image = nil
        cell.nameLabel.text = nil
        cell.costLabel.text = nil
        cell.quantityLabel.text = nil
        cell.tagLabel.text = nil
        cell.sizeLabel.text = nil
        cell.totalLabel.text = nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewController?.countInfo() ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewController?.goToItemController(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewController?.deleteItem(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Item for cart") as? CartsItemTableViewCell else {
            return UITableViewCell()
        }
        cleanCell(cell: cell)
        viewController?.getImage(indexPath: indexPath, completion: { (image) in
            DispatchQueue.main.async {
                cell.photoImageView.image = image
            }
        })
        cell.nameLabel.text = viewController?.getName(index: indexPath.row)
        cell.costLabel.text = viewController?.getCost(index: indexPath.row)
        cell.quantityLabel.text = viewController?.getQuantity(index: indexPath.row)
        cell.tagLabel.text = viewController?.getTag(index: indexPath.row)
        cell.sizeLabel.text = viewController?.getSize(index: indexPath.row)
        cell.totalLabel.text = viewController?.getTotal(index: indexPath.row)
        cell.hideButton()
        cell.minusButtonTicked = { cell in
            self.viewController?.changeQuantity(at: indexPath.row)
            cell.quantityLabel.text = self.viewController?.getQuantity(index: indexPath.row)
            cell.hideButton()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            viewController?.getImage(indexPath: indexPath, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
}
