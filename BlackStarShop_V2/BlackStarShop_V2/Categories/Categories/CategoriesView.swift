//
//  CategoriesView.swift
//  BlackStarShop_V2
//
//  Created by Norik on 19.08.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import UIKit

final class CategoriesView: CategoryTableView {
    
    //MARK: - Dependencies
    
    weak var viewController: CategoriesViewController?
    
    //MARK: - Init
    
    init(viewController: CategoriesViewController) {
        self.viewController = viewController
        super.init()
        addDelegateAndDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    func reloadCells(indexPaths: [IndexPath]) {
        categoriesTableView.reloadRows(at: indexPaths, with: .none)
    }
}

//MARK: - TableView Delegate, DatasSource, DataSourcePrefetching

extension CategoriesView: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    private func addDelegateAndDataSource() {
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
        categoriesTableView.prefetchDataSource = self
    }
    
    private func cleanCell(cell: CategoryTableViewCell) {
        cell.iconImageView.image = nil
        cell.nameLabel.text = nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewController?.countInfo() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! CategoryTableViewCell
        cleanCell(cell: cell)
        viewController?.getImage(indexPath: indexPath, completion: { (image) in
            DispatchQueue.main.async {
                cell.iconImageView.image = image
            }
        })
        cell.nameLabel.text = viewController?.getLabelText(index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewController?.goToNextController(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            viewController?.getImage(indexPath: indexPath, completion: nil)
        }
    }
}
