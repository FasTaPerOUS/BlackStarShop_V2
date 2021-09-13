//
//  CardModel.swift
//  BlackStarShop_V2
//
//  Created by Norik on 11.09.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import UIKit

final class CartModel {
    
    //MARK: - Properties
    
    var info = [ItemCD]()
    var images = [IndexPath: UIImage?]()
    var sended = [Bool]()
    
    let dataStoreManager = DataStoreManager()
    
    //MARK: - Init
    
    init() {}
    
    //MARK: - Private Methods
    
    private func cacheImage(indexPath: IndexPath, image: UIImage?) {
        images[indexPath] = image
    }
    
    //MARK: - Methods
    
    func updateModel() {
        info = dataStoreManager.getItems()
        images.removeAll()
        sended = Array(repeating: false, count: info.count)
    }
    
    func getImageAsyncAndCache(indexPath: IndexPath, completion: @escaping (UIImage) -> ()) {
        NetworkService().imageLoaderAsync(url:
        URL(string: String(mainURLString + (info[indexPath.row].mainImageURL ?? "")))) { (image) in
            DispatchQueue.main.async {
                let im: UIImage = image ?? UIImage(named: "No Logo") ?? UIImage()
                self.cacheImage(indexPath: indexPath, image: im)
                completion(im)
            }
        }
    }
    
    func removeAll() {
        dataStoreManager.removeItems()
    }
    
    func deleteItem(at index: Int) {
        dataStoreManager.deleteItem(at: index)
    }
    
    func changeQuantity(at index: Int) {
        dataStoreManager.updateQuantityOfItem(index: index)
    }
}
