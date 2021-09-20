//
//  ItemViewController.swift
//  BlackStarShop_V2
//
//  Created by Norik on 01.09.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import UIKit

protocol ItemViewProtocol {
    func countImages() -> Int
    func getImage(indexPath: IndexPath, completion: ((UIImage) -> ())?)
    func getName() -> String?
    func getPrice() -> String?
    func getDescription() -> String?
    func getCurColor() -> String?
}

final class ItemViewController: UIViewController {
    
    //MARK: - Dependencies
    
    var myView: ItemView?
    
    //MARK: - Properties
    
    var model: ItemModel?
    var currIndex = 0
    var currImageIndex = 0
    lazy var dataStoreManager: DataStoreManager = {
        return AppDelegate.shared.dataStoreManager
    }()
    
    //MARK: - Init
    
    init(info: OneItemWithAllColors) {
        super.init(nibName: nil, bundle: nil)
        title = "Описание"
        
        model = ItemModel(info: info)
        myView = ItemView(viewController: self, colorsCount: model?.info.colorName.count ?? 0)
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
        model?.convert()
        myView?.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.barTintColor = .white
        navigationController?.navigationBar.barTintColor = .white
    }
    
    //MARK: - Private Methods
    
    private func presentController(string: [String?], type: String) {
        let vc = MultiViewController(info: string , current: self, str: type)
        show(vc, sender: nil)
    }
    
    //MARK: - Methods
    
    func decreaseCurrImageIndex() -> Int{
        currImageIndex -= 1
        return currImageIndex
    }
    
    func increaseCurrImageIndex() -> Int {
        currImageIndex += 1
        return currImageIndex
    }
    
    func getColorArrayForNextController() {
        presentController(string: model?.info.colorName ?? [], type: "Color")
    }
    
    func getSizeArrayForNextController() {
        let array = model?.info.offers[currIndex].map { return $0.size } ?? []
        presentController(string: array, type: "Size")
    }
    
    func changeImagesSelection(index: Int) {
        model?.currIndex = index
        model?.convert()
    }
}

//MARK: - For myView

extension ItemViewController: ItemViewProtocol {
    
    private func getImageAsyncAndCache(indexPath: IndexPath, completion: @escaping (UIImage) -> ()) {
        model?.getImageAsyncAndCache(indexPath: indexPath, completion: { (image) in
            completion(image)
        })
    }
    
    func countImages() -> Int {
        return 1 + (model?.info.productImages[currIndex].count ?? 0)
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
    
    func getName() -> String? {
        return model?.info.name
    }
    
    func getPrice() -> String? {
        guard let pr = model?.info.price[currIndex] else { return "" }
        return pr + "₽"
    }
    
    func getDescription() -> String? {
        return model?.info.description
    }
    
    func getCurColor() -> String? {
        return model?.info.colorName[currIndex]
    }
    
}
