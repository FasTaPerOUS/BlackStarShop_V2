//
//  SubCategoriesViewController.swift
//  BlackStarShop_V2
//
//  Created by Norik on 23.08.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import UIKit

final class SubCategoriesViewController: UIViewController {
    
    //MARK: - Dependencies
    
    var myView: SubCategoriesView?
    var model: SubCategoriesModel?

    //MARK: - Init
    
    init(info: [SubCategory]) {
        super.init(nibName: nil, bundle: nil)
        title = "Подкатегории"
        
        myView = SubCategoriesView(viewController: self)
        model = SubCategoriesModel(info: info)
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.barTintColor = .white
    }
    
    //MARK: - Methods
    
    func goToNextController(index: Int) {
        let vc = ItemsViewController(id: String(model?.info[index].id ?? -999), extraID: String(model?.info.last?.id ?? -999))
        navigationController?.pushViewController(vc, animated: true)
    }
}

//for myView.categoriesTableView
extension SubCategoriesViewController: GetInfoFromCategoriesToTableViewProtocol {
    
    func countInfo() -> Int {
        return model?.info.count ?? 0
    }
    
    func getLabelText(index: Int) -> String {
        return model?.info[index].name ?? ""
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
