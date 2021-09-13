//
//  ConverterProtocol.swift
//  BlackStarShop_V2
//
//  Created by Norik on 13.09.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import Foundation

protocol ConverterProtocol {
    associatedtype TKey: CodingKey
    mutating func converter(container: KeyedDecodingContainer<TKey>)
}
