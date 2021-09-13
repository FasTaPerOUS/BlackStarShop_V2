//
//  ParsedItem.swift
//  BlackStarShop_V2
//
//  Created by Norik on 02.09.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import Foundation

struct Item: Codable, ConverterProtocol {
    
    //MARK: - Properties
    
    var name: String = ""
    var description: String = ""
    var colorName: String = ""
    var sortOrder: Int = -999
    var mainImage: String = ""
    var productImages: [ProductImage] = []
    var offers: [Offer] = []
    var price: String = ""
    var oldPrice: String = ""
    var tag: String = ""
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case colorName
        case sortOrder
        case mainImage
        case productImages
        case offers
        case price
        case oldPrice
        case tag
    }
    
    typealias TKey = CodingKeys
    
    //MARK: - Init
    
    init(name: String, description: String, colorName: String, sortOrder: Int, mainImage: String, productImages: [ProductImage], offers: [Offer], price: String, oldPrice: String, tag: String) {
        self.name = name
        self.description = description
        self.colorName = colorName
        self.sortOrder = sortOrder
        self.mainImage = mainImage
        self.productImages = productImages
        self.offers = offers
        self.price = price
        self.oldPrice = oldPrice
        self.tag = tag
    }
        
    init(from decoder: Decoder) {
        guard let container = try? decoder.container(keyedBy: TKey.self) else {
            return
        }
        converter(container: container)
    }
    
    //MARK: - Methods
    
    mutating func converter(container: KeyedDecodingContainer<TKey>) {
        do {
            name = try container.decode(String.self, forKey: .name)
            name = name.replacingOccurrences(of: "&amp;", with: "&")
            description = try container.decode(String.self, forKey: .description)
            description = description.replacingOccurrences(of: "&nbsp;", with: " ")
            description = description.replacingOccurrences(of: "  ", with: " ")
            description = description.replacingOccurrences(of: "&amp;", with: "&")
            colorName = try container.decode(String.self, forKey: .colorName)
            if let sortOrderString = try? container.decode(String.self, forKey: .sortOrder) {
                sortOrder = Int(sortOrderString) ?? -998
            } else {
                sortOrder = try container.decode(Int.self, forKey: .sortOrder)
            }
            mainImage = try container.decode(String.self, forKey: .mainImage)
            productImages = try container.decode([ProductImage].self, forKey: .productImages)
            offers = try container.decode([Offer].self, forKey: .offers)
            price = try container.decode(String.self, forKey: .price)
            if let oldPriceString = try? container.decode(String.self, forKey: .oldPrice) {
                oldPrice = oldPriceString
                tag = try container.decode(String.self, forKey: .tag)
            } else {
                oldPrice = ""
                tag = ""
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct ProductImage: Codable, ConverterProtocol {
    
    //MARK: - Properties
    
    var imageURL: String = ""
    var sortOrder: Int = -999
    
    enum CodingKeys: String, CodingKey {
        case imageURL
        case sortOrder
    }
    
    typealias TKey = CodingKeys
    
    //MARK: - Init
    
    init(imageURL: String, sortOrder: Int) {
        self.imageURL = imageURL
        self.sortOrder = sortOrder
    }
    
    init(from decoder: Decoder) {
        guard let container = try? decoder.container(keyedBy: TKey.self) else {
            return
        }
        converter(container: container)
    }
    
    //MARK: - Methods
    
    mutating func converter(container: KeyedDecodingContainer<TKey>) {
        do {
            imageURL = try container.decode(String.self, forKey: .imageURL)
            if let sortOrderString = try? container.decode(String.self, forKey: .sortOrder) {
                sortOrder = Int(sortOrderString) ?? -998
            } else {
                sortOrder = try container.decode(Int.self, forKey: .sortOrder)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct Offer: Codable, ConverterProtocol {
    
    //MARK: - Properties
    
    var size: String = ""
    var productOfferID: Int = -999
    var quantity: Int = -999
    
    enum CodingKeys: String, CodingKey {
        case size
        case productOfferID
        case quantity
    }
    
    typealias TKey = CodingKeys
    
    //MARK: - Init
    
    init(size: String, productOfferID: Int, quantity: Int) {
        self.size = size
        self.productOfferID = productOfferID
        self.quantity = quantity
    }
    
    init(from decoder: Decoder) {
        guard let container = try? decoder.container(keyedBy: TKey.self) else {
            return
        }
        converter(container: container)
    }
    
    //MARK: - Methods
    
    mutating func converter(container: KeyedDecodingContainer<TKey>) {
        do {
            size = try container.decode(String.self, forKey: .size)
            if let productOfferIDString = try? container.decode(String.self, forKey: .productOfferID) {
                productOfferID = Int(productOfferIDString) ?? -998
            } else {
                productOfferID = try container.decode(Int.self, forKey: .quantity)
            }
            if let quantityString = try? container.decode(String.self, forKey: .quantity) {
                quantity = Int(quantityString) ?? 0
            } else {
                quantity = try container.decode(Int.self, forKey: .quantity)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

typealias ItemsWithID = [String: Item]
