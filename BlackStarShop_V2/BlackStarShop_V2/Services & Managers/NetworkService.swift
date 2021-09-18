//
//  NetworkService.swift
//  BlackStarShop_V2
//
//  Created by Norik on 27.08.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import UIKit

enum Errors: Error {
    case errorNotNil(str: String)
    case dataProblem(str: String)
    case responseNil(str: String)
    case decodeProblem(str: String)
    case informationCode(str: String)
    case redirectCode(str: String)
    case clientErrorCode(str: String)
    case serverErrorCode(str: String)
    case POOP
}

extension Errors {
    var description: (String, String) {
        switch self {
        case .errorNotNil(let a), .dataProblem(let a),
             .responseNil(let a), .decodeProblem(let a):
            return (a, "Не факт что обновление тебе поможет")
        case .informationCode(let a), .redirectCode(let a),
             .clientErrorCode(let a), .serverErrorCode(let a):
            return (a, "Обнови, вдруг повезет")
        case .POOP:
            return ("Ошибка", "Обнови, вдруг повезет")
        }
    }
}

final class NetworkService {
    
    //MARK: - CategoriesLoader
    
    func categoriesLoad(url: URL, completion: @escaping (Result<[CompareIDCategory], Errors>) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            var info = [CompareIDCategory]()
            
            if error != nil {
                completion(.failure(Errors.errorNotNil(str: "Ошибка")))
                return
            }
            guard let data = data else {
                completion(.failure(Errors.dataProblem(str: "Проблема с датой")))
                return
            }
            guard let httpRresponse = response as? HTTPURLResponse else {
                completion(.failure(Errors.responseNil(str: "Response Error")))
                return
            }
            
            switch httpRresponse.statusCode {
            case 100...199:
                completion(.failure(Errors.informationCode(str: "Информационная проблема")))
                return
            case 300...399:
                completion(.failure(Errors.redirectCode(str: "Перенаправления какие-то")))
                return
            case 400...499:
                completion(.failure(Errors.clientErrorCode(str: "Клиентская проблема")))
                return
            case 500...599:
                completion(.failure(Errors.serverErrorCode(str: "Серверу плохо")))
                return
            default: break
            }
            
            let decoder = JSONDecoder()
            do {
                let z = try decoder.decode(Welcome.self, from: data)
                for (key, value) in z {
                    // исключаю категории с пустыми подкатегориями и товарами
                    if value.subCategories.count == 0 { continue }
                    info.append(CompareIDCategory(id: key, myStruct: value))
                }
                info.sort(by: {$0.myStruct.sortOrder < $1.myStruct.sortOrder})
                completion(.success(info))
            } catch {
                completion(.failure(Errors.decodeProblem(str: "Декодирование")))
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
