//
//  CardModel.swift
//  BlackStarShop_V2
//
//  Created by Norik on 11.09.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import UIKit

final class CartModel: GetAndCacheImagesService {
    
    //MARK: - Properties
    
    var info = [ItemCD]()
    
    let dataStoreManager = AppDelegate.shared.dataStoreManager
    
    //MARK: - Init
    
    override init() {}
    
    //MARK: - Methods
    
    override func convert() {
        imagesURL = info.map({ $0.mainImageURL ?? "" })
    }
    
    func updateModel() -> [ItemCD] {
        info = dataStoreManager.getItems()
        convert()
        return info
    }
    
    func deleteImages() {
        images.removeAll()
        sended = Array(repeating: false, count: info.count)
    }
    
    func removeAll() {
        dataStoreManager.removeItems()
    }
    
    func deleteItem(at index: Int) {
        dataStoreManager.deleteItem(name: info[index].name ?? "",
                                    color: info[index].colorName ?? "",
                                    size: info[index].size ?? "")
    }
    
    func changeQuantity(at index: Int) {
        dataStoreManager.updateQuantityOfItem(name: info[index].name ?? "",
                                              color: info[index].colorName ?? "",
                                              size: info[index].size ?? "")
    }
}
