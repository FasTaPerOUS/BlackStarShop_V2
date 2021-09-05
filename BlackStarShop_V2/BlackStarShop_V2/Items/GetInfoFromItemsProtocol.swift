//
//  GetInfoFromItemsProtocol.swift
//  BlackStarShop_V2
//
//  Created by Norik on 01.09.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import UIKit

@objc protocol GetInfoFromItemsProtocol {
    
    func countItems() -> Int
    func getName(index: Int) -> String?
    func getImage(indexPath: IndexPath, completion: ((UIImage) -> ())?)
    func getOldPrice(index: Int) -> NSAttributedString?
    func getCurPrice(index: Int) -> String?
    @objc optional func getDescription(index: Int) -> String?
    @objc optional func getCurColor(index: Int) -> String?
}
