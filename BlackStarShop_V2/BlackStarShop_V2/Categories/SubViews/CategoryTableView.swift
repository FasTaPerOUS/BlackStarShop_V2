//
//  CategoryTableView.swift
//  BlackStarShop_V2
//
//  Created by Norik on 19.08.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import UIKit

class CategoryTableView: UIView {
    
    //MARK: - UI

    lazy var categoriesTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: "CategoryCell")
        return tableView
    }()
    
    //MARK: - Init
    
    init() {
        super.init(frame: .zero)
        addSuvbiews()
        setupConstraints() 
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Methods
    
    private func addSuvbiews() {
        addSubview(categoriesTableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            categoriesTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            categoriesTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            categoriesTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            categoriesTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor)
        ])
    }
    
    //MARK: - Methods
    
    func reloadData() {
        categoriesTableView.reloadData()
    }
}
