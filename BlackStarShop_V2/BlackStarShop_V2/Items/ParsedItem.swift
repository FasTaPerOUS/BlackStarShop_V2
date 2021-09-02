//
//  ParsedItem.swift
//  BlackStarShop_V2
//
//  Created by Norik on 02.09.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import Foundation

struct Item: Codable {
    var name: String
    var description: String
    let colorName: String
    let sortOrder: Int
    let mainImage: String
    let productImages: [ProductImage]
    let offers: [Offer]
    let price: String
    let oldPrice: String
    let tag: String
    
    private enum CodingKeys: String, CodingKey {
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
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        name = try! container.decode(String.self, forKey: .name)
        name = name.replacingOccurrences(of: "&amp;", with: "&")
        description = try! container.decode(String.self, forKey: .description)
        description = description.replacingOccurrences(of: "&nbsp;", with: " ")
        description = description.replacingOccurrences(of: "  ", with: " ")
        description = description.replacingOccurrences(of: "&amp;", with: "&")
        colorName = try! container.decode(String.self, forKey: .colorName)
        if let sortOrderString = try? container.decode(String.self, forKey: .sortOrder) {
            sortOrder = Int(sortOrderString)!
        } else {
            sortOrder = try! container.decode(Int.self, forKey: .sortOrder)
        }
        mainImage = try! container.decode(String.self, forKey: .mainImage)
        productImages = try! container.decode([ProductImage].self, forKey: .productImages)
        offers = try! container.decode([Offer].self, forKey: .offers)
        price = try! container.decode(String.self, forKey: .price)
        if let oldPriceString = try? container.decode(String.self, forKey: .oldPrice) {
            oldPrice = oldPriceString
            tag = try! container.decode(String.self, forKey: .tag)
        } else {
//            oldPrice = "No old price"
//            tag = "No discount"
            oldPrice = ""
            tag = ""
        }
    }
}

struct ProductImage: Codable {
    let imageURL: String
    let sortOrder: Int
    
    private enum CodingKeys: String, CodingKey {
        case imageURL
        case sortOrder
    }
    
    init(imageURL: String, sortOrder: Int) {
        self.imageURL = imageURL
        self.sortOrder = sortOrder
    }
    
    init(from decoder: Decoder) {
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        imageURL = try! container.decode(String.self, forKey: .imageURL)
        if let sortOrderString = try? container.decode(String.self, forKey: .sortOrder) {
            sortOrder = Int(sortOrderString)!
        } else {
            sortOrder = try! container.decode(Int.self, forKey: .sortOrder)
        }
    }
}

struct Offer: Codable {
    let size: String
    let productOfferID: Int
    let quantity: Int
    
    private enum CodingKeys: String, CodingKey {
        case size
        case productOfferID
        case quantity
    }
    
    init(size: String, productOfferID: Int, quantity: Int) {
        self.size = size
        self.productOfferID = productOfferID
        self.quantity = quantity
    }
    
    init(from decoder: Decoder) {
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        size = try! container.decode(String.self, forKey: .size)
        if let productOfferIDString = try? container.decode(String.self, forKey: .productOfferID) {
            productOfferID = Int(productOfferIDString)!
        } else {
            productOfferID = try! container.decode(Int.self, forKey: .quantity)
        }
        if let quantityString = try? container.decode(String.self, forKey: .quantity) {
            quantity = Int(quantityString) ?? 0
        } else {
            quantity = try! container.decode(Int.self, forKey: .quantity)
        }
    }
}

typealias ItemsWithID = [String: Item]
