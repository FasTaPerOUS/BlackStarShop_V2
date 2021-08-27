//
//  SubCategoriesView.swift
//  BlackStarShop_V2
//
//  Created by Norik on 23.08.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import UIKit

class SubCategoriesView: CategoryTableView {
    
    //MARK: - Dependencies
        
    weak var viewController: SubCategoriesViewController?
    
    //MARK: - Init
    
    init(viewController: SubCategoriesViewController) {
        self.viewController = viewController
        super.init()
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
}

extension SubCategoriesView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewController?.imagesCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! CategoryTableViewCell
        cell.iconImageView.image = viewController?.getImage(index: indexPath.row)
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
}
