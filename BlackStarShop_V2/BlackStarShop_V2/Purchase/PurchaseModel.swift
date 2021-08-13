//
//  PurchaseModel.swift
//  BlackStarShop_V2
//
//  Created by Norik on 30.07.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import Foundation

enum PurchaseInfoKeys: String, CaseIterable {
    case name
    case email
    case phone
    case city
    case street
    case house
    case building
    case flat
    case floor
    case entrance
    case codeOfEntrance
}

struct PurchaseInfo {
    
    func updateUserInfo(str: String, key: PurchaseInfoKeys) {
        UserDefaults.standard.set(str, forKey: key.rawValue)
    }
    
    func takeUserInfo() -> [String] {
        var str = [String]()
        for key in PurchaseInfoKeys.allCases {
            str.append(UserDefaults.standard.string(forKey: key.rawValue) ?? "")
        }
        return str
    }
}
