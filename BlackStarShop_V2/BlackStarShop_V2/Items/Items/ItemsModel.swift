//
//  ItemsModel.swift
//  BlackStarShop_V2
//
//  Created by Norik on 30.08.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import UIKit

final class ItemsModel: GetAndCacheImagesService {
    
    //MARK: - Properties
    
    var items = [Item]()
    var itemsWithAllColors = [OneItemWithAllColors]()
    
    //MARK: - Init
    
    override init() {}
    
    //MARK: - Private Methods
    
    private func creatingItemsForCollection() {
        for (index, el) in items.enumerated() {
            let i = el.price.firstIndex(of: ".") ?? el.price.endIndex
            let i2 = el.oldPrice.firstIndex(of: ".") ?? el.oldPrice.endIndex
            var oldPrice: String
            var tag: String
            if el.oldPrice == "No old price" {
                oldPrice = "No old price"
                tag = "No discount"
            } else {
                oldPrice = String(el.oldPrice[..<i2])
                tag = el.tag
            }
            let newEl = OneItemWithAllColors(name: el.name, description: el.description, colorName: [el.colorName], sortOrder: el.sortOrder, mainImage: [el.mainImage], productImages: [el.productImages], offers: [el.offers], price: [String(el.price[..<i])], oldPrice: [oldPrice], tag: [tag])
            if index == 0 {
                itemsWithAllColors.append(newEl)
            } else {
                if el.name == itemsWithAllColors[itemsWithAllColors.count - 1].name {
                    itemsWithAllColors[itemsWithAllColors.count - 1].colorName.append(el.colorName)
                    itemsWithAllColors[itemsWithAllColors.count - 1].mainImage.append(el.mainImage)
                    itemsWithAllColors[itemsWithAllColors.count - 1].price.append(String(el.price[..<i]))
                    itemsWithAllColors[itemsWithAllColors.count - 1].offers.append(el.offers)
                    itemsWithAllColors[itemsWithAllColors.count - 1].productImages.append(el.productImages)
                    itemsWithAllColors[itemsWithAllColors.count - 1].oldPrice.append(oldPrice)
                    itemsWithAllColors[itemsWithAllColors.count - 1].tag.append(tag)
                } else { itemsWithAllColors.append(newEl) }
            }
        }
    }
    
    //MARK: - Methods
    
    override func convert() {
        imagesURL = itemsWithAllColors.map({ ($0.mainImage.first ?? "") })
    }
    
    func getItems(url: URL, closure: @escaping () -> ()) {
        NetworkService().itemsLoad(url: url) { [weak self] (result) in
            switch result {
            case .success(let arr):
                for value in arr.values {
                    self?.items.append(value)
                }
                self?.items.sort(by: { $0.sortOrder < $1.sortOrder })
                self?.creatingItemsForCollection()
                self?.sended = Array(repeating: false, count: self?.itemsWithAllColors.count ?? 0)
                self?.convert()
                closure()
            case .failure(let err):
                print(err.localizedDescription)
                closure()
            }
        }
    }
}
