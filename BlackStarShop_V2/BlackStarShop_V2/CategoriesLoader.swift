//
//  CategoriesLoader.swift
//  BlackStarShop_V2
//
//  Created by Norik on 19.08.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import Foundation

final class CategoriesLoader {
    
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
                    if key == "123" && value.name == "Предзаказ" { continue }
                    info.append(CompareIDCategory(id: key, myStruct: value))
                }
                //сортирую категории по sortOrder
                info.sort(by: {$0.myStruct.sortOrder < $1.myStruct.sortOrder})
                completion(.success(info))
            } catch {
                completion(.failure(error))
            }
        }).resume()
    }
}
