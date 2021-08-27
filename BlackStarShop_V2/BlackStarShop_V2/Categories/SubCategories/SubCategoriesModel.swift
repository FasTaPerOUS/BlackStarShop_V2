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
        for el in info {
            if el.iconImage == "" {
                images.append(UIImage(named: "No Logo"))
            } else {
                guard let url = URL(string: mainURLString + el.iconImage) else {
                    images.append(UIImage(named: "No Logo"))
                    print("\(#file), \(#function), \(#line) - Не существует URL для получения иконки")
                    return
                }
                guard let imageData = try? Data(contentsOf: url),
                    let image = UIImage(data: imageData) else {
                    images.append(UIImage(named: "No Logo"))
                    print("\(#file), \(#function), \(#line) - Проблема с датой или преобразованием")
                    return
                }
                images.append(image)
            }
        }
        completion()
    }
}
