//
//  CartViewController.swift
//  BlackStarShop_V2
//
//  Created by Norik on 11.09.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import UIKit

protocol ForCartTableViewProtocol {
    func countInfo() -> Int
    func getImage(indexPath: IndexPath, completion: ((UIImage) -> ())?)
    func getName(index: Int) -> String?
    func getCost(index: Int) -> String?
    func getQuantity(index: Int) -> String?
    func getTag(index: Int) -> String?
    func getSize(index: Int) -> String?
    func getTotal(index: Int) -> String?
    func deleteItem(at index: Int)
}

protocol ForCartViewProtocol {
    func getCostForMainView() -> String
    func getDiscountForMainView() -> String
    func getTotalForMainView() -> String
    func removeAll()
}

class CartViewController: UIViewController {
    
    //MARK: - Dependencies
    
    var myView: CartView?
    var model: CartModel?
    
    //MARK: - Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
        myView = CartView(viewController: self)
        model = CartModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life cicle
    
    override func loadView() {
        super.loadView()
        view = myView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        print("OLD")
//        model?.printing()
        model?.updateModel()
        myView?.updateLabelsText()
        myView?.reloadData()
//        print("NEW")
//        model?.printing()
    }
    
    func goToItemController(index: Int) {
        let infoCD = model?.info[index]
        let info = OneItemWithAllColors(name: infoCD?.name ?? "",
                                        description: infoCD?.descript ?? "",
                                        colorName: [infoCD?.colorName ?? ""],
                                        sortOrder: -404,
                                        mainImage: [infoCD?.mainImageURL ?? ""],
                                        productImages: [
                                            [ProductImage(imageURL: infoCD?.mainImageURL ?? "",
                                                                      sortOrder: -404)]
            ],
                                        offers: [],
                                        price: [String(infoCD?.currPrice ?? -404)],
                                        oldPrice: [String(infoCD?.oldPrice ?? -404)],
                                        tag: [String(infoCD?.tag ?? "-404%")])
        let vc = ItemViewController(info: info)
        vc.myView?.hideAddButton()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToPurchaseController() {
        if countInfo() < 1 {
            let alert = UIAlertController(title: "Пустая корзина", message: "Для того, чтобы оформить заказ - в корзине должен быть хотя бы один товар", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
        } else {
            let vc = PurchaseViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension CartViewController: ForCartTableViewProtocol {
    
    private func getImageAsyncAndCache(indexPath: IndexPath, completion: @escaping (UIImage) -> ()) {
        model?.getImageAsyncAndCache(indexPath: indexPath, completion: { (image) in
            completion(image)
        })
    }
    
    func countInfo() -> Int {
        return model?.info.count ?? 0
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
                        self.myView?.reloadItems(indexPaths: [indexPath])
                    }
                }
            }
            return
        }
        guard let comp = completion else { return }
        comp(resultImage)
    }
    
    func getName(index: Int) -> String? {
        return model?.info[index].name
    }
    
    func getCost(index: Int) -> String? {
        guard let currPrice = model?.info[index].currPrice,
            let quantity = model?.info[index].quantity,
            let oldPrice = model?.info[index].oldPrice else {
                return ""
        }
        if oldPrice < 0 {
            return String(quantity * currPrice)
        } else {
            return String(quantity * oldPrice)
        }
    }
    
    func getQuantity(index: Int) -> String? {
        return String(model?.info[index].quantity ?? 0)
    }
    
    func getTag(index: Int) -> String? {
        return model?.info[index].tag
    }
    
    func getSize(index: Int) -> String? {
        return model?.info[index].size
    }
    
    func getTotal(index: Int) -> String? {
        guard let currPrice = model?.info[index].currPrice,
            let quantity = model?.info[index].quantity else {
            return ""
        }
        return String(quantity * currPrice)
    }
    
    func deleteItem(at index: Int) {
        self.model?.deleteItem(at: index)
        self.model?.updateModel()
        self.myView?.reloadData()
        self.myView?.updateLabelsText()
    }
    
    func changeQuantity(at index: Int) {
        self.model?.changeQuantity(at: index)
        self.model?.updateModel()
        self.myView?.updateLabelsText()
    }
}

extension CartViewController: ForCartViewProtocol {
    
    private func countCost() -> Int {
        var sum = 0
        for el in model?.info ?? [] {
            if el.oldPrice == -1 {
                sum += Int(el.quantity) * Int(el.currPrice)
            } else {
                sum += Int(el.quantity) * Int(el.oldPrice)
            }
        }
        return sum
    }
    
    private func countTotal() -> Int {
        var sum: Int = 0
        for el in model?.info ?? [] {
            sum += Int(el.quantity) * Int(el.currPrice)
        }
        return sum
    }
    
    func getCostForMainView() -> String {
        return String(countCost())
    }
    
    func getDiscountForMainView() -> String {
        return String(countCost() - countTotal())
    }
    
    func getTotalForMainView() -> String {
        return String(countTotal())
    }
    
    func removeAll() {
        if countInfo() > 0 {
            let alert = UIAlertController(title: "Очистить корзину", message: "Вы точно уверены что хотите очистить всю корзину?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Очистить", style: .default, handler: { _ in
                self.model?.removeAll()
                self.model?.updateModel()
                self.myView?.reloadData()
                self.myView?.updateLabelsText()
            }))
            alert.addAction(UIAlertAction(title: "Отмена", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}
