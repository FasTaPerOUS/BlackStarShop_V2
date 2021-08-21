//
//  GetInfoFromCategoriesToTableViewProtocol.swift
//  BlackStarShop_V2
//
//  Created by Norik on 20.08.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import UIKit

protocol GetInfoFromCategoriesToTableViewProtocol {
    func getLabelText(index: Int) -> String
    func getImage(index: Int) -> UIImage?
}
