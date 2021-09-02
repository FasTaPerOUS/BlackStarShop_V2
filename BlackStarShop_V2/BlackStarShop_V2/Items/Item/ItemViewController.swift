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
    func getImage(index: Int) -> UIImage?
    func getName() -> String?
    func getPrice() -> String?
    func getDescription() -> String?
    func getCurColor() -> String?
    func showColorsController()
}

final class ItemViewController: UIViewController {
    
    //MARK: - Dependencies
    
    var myView: ItemView?
    
    //MARK: - Properties
    
    var model: ItemModel?
    var currIndex = 0
    var currImageIndex = 0
    
    //MARK: - Init
    
    init(info: OneItemWithAllColors) {
        model = ItemModel(info: info)
        super.init(nibName: nil, bundle: nil)
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
        DispatchQueue.main.async {
            self.model?.imagesLoad(index: self.currIndex) { [weak self] in
                self?.myView?.configurateLeftRightButtons()
                self?.myView?.reloadData()
            }
        }
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
    
}

extension ItemViewController: ItemViewProtocol {
    func countImages() -> Int {
        return model?.images.count ?? 0
    }
    
    func getImage(index: Int) -> UIImage? {
        return model?.images[index]
    }
    
    func getName() -> String? {
        return model?.info.name
    }
    
    func getPrice() -> String? {
        return model?.info.price[currIndex]
    }
    
    func getDescription() -> String? {
        return model?.info.description
    }
    
    func getCurColor() -> String? {
        return model?.info.colorName[currIndex]
    }
    
    func showColorsController() {
        return
    }
}
