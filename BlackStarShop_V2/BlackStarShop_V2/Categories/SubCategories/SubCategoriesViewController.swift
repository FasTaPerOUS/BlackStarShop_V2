//
//  SubCategoriesViewController.swift
//  BlackStarShop_V2
//
//  Created by Norik on 23.08.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import UIKit

class SubCategoriesViewController: UIViewController {
    
    //MARK: - Dependencies
    
    var myView: SubCategoriesView?
    
    //MARK: - Properties
    
    var model: SubCategoriesModel
    
    //MARK: - Init
    
    init(info: [SubCategory]) {
        model = SubCategoriesModel(info: info)
        super.init(nibName: nil, bundle: nil)
        title = "Подкатегории"
        myView = SubCategoriesView(viewController: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life cycle
    
    override func loadView() {
        super.loadView()
        view = myView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.global(qos: .userInteractive).async {
            self.model.downloadImages {
                DispatchQueue.main.async {
                    self.myView?.reloadData()
                }
            }
        }
    }
    
    //MARK: - Methods
    
    func imagesCount() -> Int {
        return model.images.count
    }
    
    func goToNextController(index: Int) {
        
    }
}

//for myView.categoriesTableView
extension SubCategoriesViewController: GetInfoFromCategoriesToTableViewProtocol {
    func getLabelText(index: Int) -> String {
        return model.info[index].name
    }
    
    func getImage(index: Int) -> UIImage? {
        return model.images[index]
    }
}
