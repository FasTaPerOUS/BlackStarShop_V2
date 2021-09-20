//
//  Page.swift
//  BlackStarShop_V2UITests
//
//  Created by Norik on 20.09.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import Foundation
import XCTest

protocol Page {
    var app: XCUIApplication { get }
    
    init(app: XCUIApplication)
}
