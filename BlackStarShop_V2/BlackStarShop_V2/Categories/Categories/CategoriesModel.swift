//
//  CategoriesModel.swift
//  BlackStarShop_V2
//
//  Created by Norik on 04.09.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import UIKit

class CategoriesModel {
    
    //MARK: - Properties
    
    var info = [CompareIDCategory]()
    var images = [IndexPath: UIImage?]()
    var sended = [Bool]()
    
    //MARK: - Init
    
    init(info: [CompareIDCategory], comletion: () -> ()) {
        self.info = info
        sended = Array(repeating: false, count: info.count)
        comletion()
    }
    
    //MARK: - Methods
    
    func cacheImage(indexPath: IndexPath, image: UIImage) {
        images[indexPath] = image
    }
    
    func getImageAsyncAndCache(indexPath: IndexPath, completion: @escaping (UIImage) -> ()) {
        NetworkService().imageLoaderAsync(url:
        URL(string: String(mainURLString + info[indexPath.row].myStruct.iconImage))) { (image) in
            DispatchQueue.main.async {
                let im: UIImage = image ?? UIImage(named: "No Logo") ?? UIImage()
                self.cacheImage(indexPath: indexPath, image: im)
                completion(im)
            }
        }
    }
}
