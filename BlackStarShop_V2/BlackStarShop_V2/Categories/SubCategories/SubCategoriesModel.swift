//
//  SubCategoriesModel.swift
//  BlackStarShop_V2
//
//  Created by Norik on 23.08.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import UIKit

class SubCategoriesModel: GetAndCacheImagesService {
    
    //MARK: - Properties
    
    var info = [SubCategory]()
    
    //MARK: - Init
    
    init(info: [SubCategory]) {
        super.init()
        self.info = info
        convert()
        sended = Array(repeating: false, count: info.count)
    }
       
    //MARK: - Methods
    
    override func convert() {
        imagesURL = info.map({ $0.iconImage })
    }
}
