//
//  NetworkService.swift
//  BlackStarShop_V2
//
//  Created by Norik on 27.08.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import UIKit

final class NetworkService {
    
    //MARK: - CategoriesLoader
    
    func categoriesLoad(completion: @escaping (Result<[CompareIDCategory], Error>) -> Void) {
        URLSession.shared.dataTask(with: categoriesURL, completionHandler: { (data, response, error) in
            var info = [CompareIDCategory]()
            guard let data = data else { return }
            let decoder = JSONDecoder()
            do {
                let z = try decoder.decode(Welcome.self, from: data)
                for (key, value) in z {
                    /* из-за кривой апишки я добавил подобное условие
                     в апи есть повтор категории "Предзаказ" под разными ключами,
                     поэтому я исключаю второй экземпляр */
                    if key == "123" && value.name == "Предзаказ" || value.subCategories.count == 0 { continue }
                    info.append(CompareIDCategory(id: key, myStruct: value))
                }
                info.sort(by: {$0.myStruct.sortOrder < $1.myStruct.sortOrder})
                completion(.success(info))
            } catch {
                completion(.failure(error))
            }
        }).resume()
    }
    
    //MARK: - ImagesLoader
    
    func imagesLoader(urls: [URL?] ,completion: @escaping ([UIImage?]) -> Void) {
        var images = [UIImage?]()
        for url in urls {
            if url == nil {
                images.append(UIImage(systemName: "No logo"))
            } else {
                guard let imageData = try? Data(contentsOf: url!),
                    let image = UIImage(data: imageData) else {
                    images.append(UIImage(named: "No Logo"))
                    print("\(#file), \(#function), \(#line) - Проблема с датой или преобразованием")
                    continue
                }
                images.append(image)
            }
        }
        completion(images)
    }
    
    //MARK: - ItemsLoader
    
    func itemsLoad(url: URL, completion: @escaping (Result<ItemsWithID, Error>) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            do {
                completion(.success(try decoder.decode(ItemsWithID.self, from: data)))
            } catch {
                completion(.failure(error))
            }
        }).resume()
    }
    
    //MARK: - urls.count images async loader
    
    func imagesLoaderAsync(urls: [URL?] ,completion: @escaping ([UIImage?]) -> Void) {
        var images = [UIImage?]()
        let imagesLoaderQueue = DispatchQueue(label: "imagesLoaderAsync")
        imagesLoaderQueue.sync {
            let group = DispatchGroup()
            for url in urls {
                group.enter()
                guard let curURL = url else {
                    images.append(UIImage(systemName: "No logo"))
                    continue
                }
                URLSession.shared.dataTask(with: curURL) { (data, response, error) in
                    if error != nil { images.append(UIImage(systemName: "No logo")) }
                    guard let imageData = data,
                        let image = UIImage(data: imageData) else {
                        images.append(UIImage(named: "No Logo"))
                        print("\(#file), \(#function), \(#line) - Проблема с датой или преобразованием")
                        group.leave()
                        return
                    }
                    images.append(image)
                    group.leave()
                }.resume()
            }
            group.wait()
            completion(images)
        }
    }
    
    //MARK: - 1 image async loader
    
    func imageLoaderAsync(url: URL? ,completion: @escaping (UIImage?) -> ()) {
        DispatchQueue.global(qos: .userInteractive).async {
            guard let curURL = url else {
                completion(nil)
                return
            }
            URLSession.shared.dataTask(with: curURL) { (data, response, error) in
                if error != nil {
                    completion(nil)
                    return
                }
                guard let imageData = data,
                    let image = UIImage(data: imageData) else {
                    completion(nil)
                    print("\(#file), \(#function), \(#line) - Проблема с датой или преобразованием")
                    return
                }
                completion(image)
            }.resume()
        }
    }
}
