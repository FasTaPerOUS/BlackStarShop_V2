//
//  ItemsViewController.swift
//  BlackStarShop_V2
//
//  Created by Norik on 27.08.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import UIKit

protocol ItemsViewProtocol {
    
    func countItems() -> Int
    func getName(index: Int) -> String?
    func getImage(indexPath: IndexPath, completion: ((UIImage) -> ())?)
    func getOldPrice(index: Int) -> NSAttributedString?
    func getCurPrice(index: Int) -> String?
}

final class ItemsViewController: UIViewController {
    
    //MARK: - Dependencies
    
    var myView: ItemsView?
    var model: ItemsModel?
    
    //MARK: - Properties
    
    var id: String?
    var extraID: String?
    
    //MARK: - Init
    
    init(id: String, extraID: String) {
        super.init(nibName: nil, bundle: nil)
        title = "Товары"
        
        self.id = id
        self.extraID = extraID
        
        myView = ItemsView(viewController: self)
        model = ItemsModel()
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
        takeInfoFromApi(searchID: id)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.barTintColor = .white
    }
    
    //MARK: - Private Methods
    
    private func takeInfoFromApi(searchID: String?) {
        guard let mID = searchID, let url = URL(string: itemsURLString + mID) else {
            return
        }
        model?.getItems(url: url, closure: { [weak self] error in
            if error != nil {
                let alert = UIAlertController(title: error!.description.0, message: error!.description.1, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Обновить", style: .default, handler: { _ in
                    self?.takeInfoFromApi(searchID: mID)
                }))
                self?.present(alert, animated: true, completion: nil)
            }
            DispatchQueue.main.async {
                self?.myView?.reloadData()
                self?.myView?.configurateView()
            }
        })
    }
    
    //MARK: - Methods
    
    func itemsIsEmpty() -> Bool {
        return model?.itemsWithAllColors.isEmpty ?? false
    }
    
    func loadAllItems() {
        takeInfoFromApi(searchID: extraID)
    }
    
    func goToNextController(index: Int) {
        guard let info = model?.itemsWithAllColors[index] else { return }
        let vc = ItemViewController(info: info)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: - For myView.itemsCollectionView

extension ItemsViewController: ItemsViewProtocol {
    
    private func getImageAsyncAndCache(indexPath: IndexPath, completion: @escaping (UIImage) -> ()) {
        model?.getImageAsyncAndCache(indexPath: indexPath, completion: { (image) in
            completion(image)
        })
    }
    
    func countItems() -> Int {
        return model?.itemsWithAllColors.count ?? 0
    }
    
    func getName(index: Int) -> String? {
        return model?.itemsWithAllColors[index].name
    }
    
    func getImage(indexPath: IndexPath, completion: ((UIImage) -> ())?) {
        guard let image = model?.images[indexPath], let resultImage = image else {
            guard let checker = model?.sended[indexPath.row] else {
                return
            }
            if !checker {
                model?.sended[indexPath.row] = true
                getImageAsyncAndCache(indexPath: indexPath) { [weak self] _ in
                    DispatchQueue.main.async {
                        self?.myView?.reloadItems(indexPaths: [indexPath])
                    }
                }
            }
            return
        }
        guard let comp = completion else { return }
        comp(resultImage)
    }
    
    // ̶s̶t̶r̶i̶k̶e̶t̶h̶r̶o̶u̶g̶h̶ ̶t̶e̶x̶t̶
    func getOldPrice(index: Int) -> NSAttributedString? {
        return NSAttributedString(string: model?.itemsWithAllColors[index].oldPrice.first ?? "",
                                  attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
    }
    
    func getCurPrice(index: Int) -> String? {
        return model?.itemsWithAllColors[index].price.first
    }
}
