//
//  GetAndCacheImagesService.swift
//  BlackStarShop_V2
//
//  Created by Norik on 18.09.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import UIKit

protocol ConverterForGetAndCacheImagesServiceProtocol {
    func convert()
}

class GetAndCacheImagesService: ConverterForGetAndCacheImagesServiceProtocol {
    var imagesURL = [String]()
    var images = [IndexPath: UIImage?]()
    var sended = [Bool]()
    
    private func cacheImage(indexPath: IndexPath, image: UIImage) {
        images[indexPath] = image
    }
    
    func getImageAsyncAndCache(indexPath: IndexPath, completion: @escaping (UIImage) -> ()) {
        NetworkService().imageLoaderAsync(url:
        URL(string: String(mainURLString + imagesURL[indexPath.row]))) { [weak self] (image) in
            DispatchQueue.main.async {
                let im: UIImage = image ?? UIImage(named: "No Logo") ?? UIImage()
                self?.cacheImage(indexPath: indexPath, image: im)
                completion(im)
            }
        }
    }
    
    func convert() {
        return
    }
}
