//
//  CategoryModel.swift
//  BlackStarShop_V2
//
//  Created by Norik on 19.08.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import Foundation

fileprivate protocol ConverterProtocol {
    associatedtype TKey: CodingKey
    mutating func converter(container: KeyedDecodingContainer<TKey>)
}

struct Category: Codable, ConverterProtocol {
    
    enum CodingKeys: String, CodingKey {
        case name
        case sortOrder
        case iconImage
        case subCategories = "subcategories"
    }
    
    //MARK: - Generics
    
    fileprivate typealias TKey = CodingKeys

    //MARK: - Properties
    
    var name: String = ""
    var sortOrder: Int = -999
    var iconImage: String = ""
    var subCategories: [SubCategory] = []
    
    //MARK: - Init
    
    init(from decoder: Decoder) {
        let container = try! decoder.container(keyedBy: TKey.self)
        converter(container: container)
    }
    
    //MARK: - Fileprivate Methods
    
    fileprivate mutating func converter(container: KeyedDecodingContainer<TKey>) {
        do {
            name = try container.decode(String.self, forKey: .name)
            iconImage = try container.decode(String.self, forKey: .iconImage)
            if let sortOrderString = try? container.decode(String.self, forKey: .sortOrder) {
                sortOrder = Int(sortOrderString) ?? -998
            } else {
                sortOrder = try container.decode(Int.self, forKey: .sortOrder)
            }
            subCategories = try container.decode([SubCategory].self, forKey: .subCategories)
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

struct SubCategory: Codable, ConverterProtocol {
    
    //MARK: - Coding keys
    
    fileprivate enum CodingKeys: String, CodingKey {
        case id
        case iconImage
        case sortOrder
        case name
        case type
    }
    
    //MARK: - Generics
    
    fileprivate typealias TKey = CodingKeys
    
    //MARK: - Properties
    
    var id: Int = -999
    var iconImage: String = ""
    var sortOrder: Int = -999
    var name: String = ""
    var type: String = ""
    
    //MARK: - Init
    
    init(from decoder: Decoder) {
        let container = try! decoder.container(keyedBy: TKey.self)
        converter(container: container)
    }
    
    //MARK: - Fileprivate Methods
    
    fileprivate mutating func converter(container: KeyedDecodingContainer<TKey>) {
        do {
            if let idString = try? container.decode(String.self, forKey: .id) {
                id = Int(idString) ?? -998
            } else {
                id = try container.decode(Int.self, forKey: .id)
            }
            if let sortOrderString = try? container.decode(String.self, forKey: .sortOrder) {
                sortOrder = Int(sortOrderString) ?? -998
            } else {
                sortOrder = try container.decode(Int.self, forKey: .sortOrder)
            }
            iconImage = try container.decode(String.self, forKey: .iconImage)
            name = try container.decode(String.self, forKey: .name)
            type = try container.decode(String.self, forKey: .type)
        } catch {
            print(error.localizedDescription)
        }
    }
}

typealias Welcome = [String: Category]

//используется для удобства сортировки
struct CompareIDCategory {
    let id: String
    let myStruct: Category
}

