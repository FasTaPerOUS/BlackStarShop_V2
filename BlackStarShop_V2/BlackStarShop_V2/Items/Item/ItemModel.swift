//
//  ItemModel.swift
//  BlackStarShop_V2
//
//  Created by Norik on 29.08.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import UIKit

final class ItemModel: GetAndCacheImagesService {
    
    //MARK: Properties
    
    let info: OneItemWithAllColors
    var currIndex = 0
    
    //MARK: - Init
    
    init(info: OneItemWithAllColors) {
        self.info = info
    }
    
    //MARK: - Methods
    
    override func convert() {
        imagesURL = [info.mainImage[currIndex]]
        let _ = info.productImages[currIndex].map {
            imagesURL.append($0.imageURL)
        }
        createSendedArr()
    }
    
    func createSendedArr() {
        images.removeAll()
        sended = Array(repeating: false, count: imagesURL.count)
    }
    
}
