//
//  OneItemWithAllColors.swift
//  BlackStarShop_V2
//
//  Created by Norik on 14.09.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import Foundation

struct OneItemWithAllColors {
    let name: String
    let description: String
    var colorName: [String]
    let sortOrder: Int
    var mainImage: [String]
    var productImages: [[ProductImage]]
    var offers: [[Offer]]
    var price: [String]
    var oldPrice: [String]
    var tag: [String]
}
