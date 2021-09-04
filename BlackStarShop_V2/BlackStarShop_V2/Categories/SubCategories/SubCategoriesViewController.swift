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
    
    var model: SubCategoriesModel?
    
    //MARK: - Init
    
    init(info: [SubCategory]) {
        super.init(nibName: nil, bundle: nil)
        title = "Подкатегории"
        myView = SubCategoriesView(viewController: self)
        model = SubCategoriesModel(info: info, comletion: {
//            DispatchQueue.main.async {
//                self.myView?.reloadData()
//            }
        })
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
//        DispatchQueue.global(qos: .userInteractive).async {
//            self.model.downloadImages {
//                DispatchQueue.main.async {
//                    self.myView?.reloadData()
//                }
//            }
//        }
    }
    
    //MARK: - Methods
    
    func imagesCount() -> Int {
        return model?.info.count ?? 0
    }
    
    func goToNextController(index: Int) {
        let vc = ItemsViewController(id: String(model?.info[index].id ?? -999), extraID: String(model?.info.last?.id ?? -999))
        navigationController?.pushViewController(vc, animated: true)
    }
}

//for myView.categoriesTableView
extension SubCategoriesViewController: GetInfoFromCategoriesToTableViewProtocol {
    func getLabelText(index: Int) -> String {
        return model?.info[index].name ?? ""
    }
    
    func getImage(index: Int) -> UIImage? {
        return UIImage()
    }
    
    func getImage1(indexPath: IndexPath, completion: ((UIImage) -> ())?) {
        guard let image = model?.images[indexPath], let resultImage = image else {
            getImageAsyncAndCache(indexPath: indexPath) { image in
                guard let comp = completion else { return }
                comp(image)
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
