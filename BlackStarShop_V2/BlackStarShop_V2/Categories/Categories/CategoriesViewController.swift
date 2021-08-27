//
//  CategoriesViewController.swift
//  BlackStarShop_V2
//
//  Created by Norik on 19.08.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {

    //MARK: - Dependencies
    
    var myView: CategoriesView?
    
    //MARK: - Properties
    
    var info = [CompareIDCategory]()
    
    //MARK: - Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
        myView = CategoriesView(viewController: self)
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
        NetworkService().categoriesLoad { result in
            switch result {
            case .success(let z):
                DispatchQueue.main.async {
                    self.info = z
                    self.myView?.reloadData()
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    //MARK: - Private Methods
    
    private func goToSubCategoriesController(index: Int) {
        let nextController = SubCategoriesViewController(info: info[index].myStruct.subCategories)
        navigationController?.pushViewController(nextController, animated: true)
    }

    private func goToItemsController(index: Int) {
//        let nextController = ItemsController()
//        present(nextController, animated: true)
    }

    
    //MARK: - Methods
    
    func goToNextController(index: Int) {
        if info[index].myStruct.subCategories.count != 0 {
            goToSubCategoriesController(index: index)
        } else {
//            goToItemsController(index: index)
        }
    }
    
}

//for myView.categoriesTableView
extension CategoriesViewController: GetInfoFromCategoriesToTableViewProtocol {
    
    func getImage(index: Int) -> UIImage? {
        if info[index].myStruct.iconImage != "" {
            guard let url = URL(string: mainURLString + info[index].myStruct.iconImage) else {
                print("\(#file), \(#function), \(#line) - No URL for icon of category")
                return nil
            }
            do {
                let data = try Data(contentsOf: url)
                return UIImage(data: data)
            } catch {
                print("\(#file), \(#function), \(#line) data problem: \(error.localizedDescription)")
                return UIImage(named: "No Logo")
            }
        } else { return UIImage(named: "No Logo") }
    }
    
    func getLabelText(index: Int) -> String {
        return info[index].myStruct.name
    }
    
}
