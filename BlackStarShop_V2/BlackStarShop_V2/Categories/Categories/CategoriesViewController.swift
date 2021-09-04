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
    var model: CategoriesModel?
    
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
                self.model = CategoriesModel(info: z, comletion: {
                    DispatchQueue.main.async {
                        self.myView?.reloadData()
                    }
                })
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    //MARK: - Private Methods
    
    private func goToSubCategoriesController(index: Int) {
        guard let info = model?.info[index].myStruct.subCategories else { return }
        let nextController = SubCategoriesViewController(info: info)
        navigationController?.pushViewController(nextController, animated: true)
    }

    private func goToItemsController(index: Int) {
//        let nextController = ItemsController()
//        present(nextController, animated: true)
    }

    
    //MARK: - Methods
    
    func goToNextController(index: Int) {
        guard let subCaterories = model?.info[index].myStruct.subCategories else { return }
        if subCaterories.count != 0 {
            goToSubCategoriesController(index: index)
        } else {
//            goToItemsController(index: index)
        }
    }
    
}

//for myView.categoriesTableView
extension CategoriesViewController: GetInfoFromCategoriesToTableViewProtocol {
    
    func countInfo() -> Int {
        return model?.info.count ?? 0
    }
    
    func getLabelText(index: Int) -> String {
        return model?.info[index].myStruct.name ?? ""
    }
    
    func getImage(indexPath: IndexPath, completion: ((UIImage) -> ())?) {
           guard let image = model?.images[indexPath], let resultImage = image else {
               guard let checker = model?.sended[indexPath.row] else {
                   return
               }
               if !checker {
                   model?.sended[indexPath.row] = true
                   getImageAsyncAndCache(indexPath: indexPath) { _ in
                       DispatchQueue.main.async {
                           self.myView?.categoriesTableView.reloadRows(at: [indexPath], with: .none)
                       }
                   }
               }
               return
           }
           guard let comp = completion else { return }
           comp(resultImage)
       }
       
       private func getImageAsyncAndCache(indexPath: IndexPath, completion: @escaping (UIImage) -> ()) {
           model?.getImageAsyncAndCache(indexPath: indexPath, completion: { (image) in
               completion(image)
           })
       }
    
}
