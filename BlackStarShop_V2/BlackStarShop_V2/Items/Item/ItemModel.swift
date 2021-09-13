//
//  ItemModel.swift
//  BlackStarShop_V2
//
//  Created by Norik on 29.08.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import UIKit

final class ItemModel {
    
    //MARK: Properties
    
    let info: OneItemWithAllColors
    var images = [UIImage?]()
    
    //MARK: - Init
    
    init(info: OneItemWithAllColors) {
        self.info = info
    }
    
    //MARK: - Methods
    
    func imagesLoad(index: Int, completion: @escaping () -> ()) {
        images = []
        let ns = NetworkService()
        ns.imagesLoader(urls: [URL(string: mainURLString + info.mainImage[index])]) { [weak self] (image) in
            self?.images = image
        }
        var urls = [URL?]()
        for url in info.productImages[index] {
            urls.append(URL(string: mainURLString + url.imageURL))
        }
        ns.imagesLoaderAsync(urls: urls) { [weak self] (images) in
            self?.images += images
        }
        completion()
    }
    
}
