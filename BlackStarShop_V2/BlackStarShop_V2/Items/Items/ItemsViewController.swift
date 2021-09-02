//
//  ItemsViewController.swift
//  BlackStarShop_V2
//
//  Created by Norik on 27.08.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import UIKit

class ItemsViewController: UIViewController {
    
    //MARK: - Dependencies
    
    var myView: ItemsView?
    var model: ItemsModel?
    
    //MARK: - Properties
    
    var id: String?
    
    //MARK: - Init
    
    init(id: String, extraID: String) {
        super.init(nibName: nil, bundle: nil)
        title = "Товары"
        
        self.id = id
        myView = ItemsView(viewController: self)
        model = ItemsModel(extraID: extraID)
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
        guard let id = id, let url = URL(string: itemsURLString + id) else {
            return
        }
        model?.getItems(url: url, closure: { [weak self] in
            DispatchQueue.main.async {
                self?.myView?.reloadData()
                self?.myView?.configurateView()
            }
        })
    }
    
    //MARK: - Methods
    
    func itemsIsEmpty() -> Bool {
        return model?.images.isEmpty ?? false
    }
    
    func goToNextController(index: Int) {
        guard let info = model?.itemsWithAllColors[index] else { return }
        let vc = ItemViewController(info: info)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

//for collectionView
extension ItemsViewController: GetInfoFromItemsProtocol {
    
    func countItems() -> Int {
        return model?.images.count ?? 0
    }
    
    func getName(index: Int) -> String? {
        return model?.itemsWithAllColors[index].name
    }
    
    func getImage(index: Int) -> UIImage? {
        return model?.images[index]
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
