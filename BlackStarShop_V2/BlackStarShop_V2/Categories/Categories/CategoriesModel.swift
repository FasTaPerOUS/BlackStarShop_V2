//
//  CategoriesModel.swift
//  BlackStarShop_V2
//
//  Created by Norik on 04.09.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import UIKit

final class CategoriesModel: GetAndCacheImagesService {
    
    //MARK: - Properties
    
    var info = [CompareIDCategory]()
    
    //MARK: - Init
    
    override init() {}
    
    //MARK: - Methods

    override func convert() {
        imagesURL = info.map({ $0.myStruct.iconImage })
    }
    
    func updateInfo(info: [CompareIDCategory]) {
        self.info = info
        convert()
        sended = Array(repeating: false, count: info.count)
    }
}
