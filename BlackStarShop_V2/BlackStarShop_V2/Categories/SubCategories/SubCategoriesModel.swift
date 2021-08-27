//
//  SubCategoriesModel.swift
//  BlackStarShop_V2
//
//  Created by Norik on 23.08.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import UIKit

fileprivate protocol IconsDownloadForSCProtocol {
    mutating func downloadImages(completion: @escaping () -> ())
}

struct SubCategoriesModel: IconsDownloadForSCProtocol {
    
    //MARK: - Properties
    
    var info = [SubCategory]()
    var extraID = -999
    var images = [UIImage?]()
    
    //MARK: - Init
    
    init(info: [SubCategory]) {
        self.info = info
    }
    
    //MARK: - Methods
    
    func imagesCount() -> Int {
        return images.count
    }
    
    mutating func downloadImages(completion: @escaping () -> ()) {
        var urls = [URL?]()
        for el in info {
            let url = URL(string: mainURLString + el.iconImage)
            urls.append(url)
        }
        var thisStruct = self
        NetworkService().imagesLoader(urls: urls) { (images) in
            thisStruct.images = images
        }
        self = thisStruct
        completion()
    }
}
