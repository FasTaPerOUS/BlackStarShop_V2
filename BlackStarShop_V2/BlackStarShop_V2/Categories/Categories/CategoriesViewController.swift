//
//  CategoriesViewController.swift
//  BlackStarShop_V2
//
//  Created by Norik on 19.08.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import UIKit

final class CategoriesViewController: UIViewController {

    //MARK: - Dependencies
    
    var myView: CategoriesView?
    var model: CategoriesModel?
    
    //MARK: - Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Категории"
        
        myView = CategoriesView(viewController: self)
        model = CategoriesModel()
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
        takeInfoFromApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.barTintColor = .white
    }
    
    //MARK: - Private Methods
    
    private func takeInfoFromApi() {
        guard let url = URL(string: categoriesURLString) else { return }
        NetworkService().categoriesLoad(url: url) { result in
            switch result {
            case .success(let z):
                DispatchQueue.main.async {
                    self.model?.updateInfo(info: z)
                    self.myView?.reloadData()
                }
            case .failure(let err):
                let alert = UIAlertController(title: err.description.0, message: err.description.1, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Обновить", style: .default, handler: { _ in
                    self.takeInfoFromApi()
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func goToSubCategoriesController(index: Int) {
        guard let info = model?.info[index].myStruct.subCategories else { return }
        let nextController = SubCategoriesViewController(info: info)
        navigationController?.pushViewController(nextController, animated: true)
    }
    
    //MARK: - Methods
    
    func goToNextController(index: Int) {
        goToSubCategoriesController(index: index)
    }
    
}

//MARK: - For myView.categoriesTableView

extension CategoriesViewController: GetInfoFromCategoriesToTableViewProtocol {
    
    private func getImageAsyncAndCache(indexPath: IndexPath, completion: @escaping (UIImage) -> ()) {
        model?.getImageAsyncAndCache(indexPath: indexPath, completion: { (image) in
            completion(image)
        })
    }
    
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
                        self.myView?.reloadCells(indexPaths: [indexPath])
                    }
                }
            }
            return
        }
        guard let comp = completion else { return }
        comp(resultImage)
   }
}
