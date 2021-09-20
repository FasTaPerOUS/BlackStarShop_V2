//
//  CategoryScreen.swift
//  BlackStarShop_V2UITests
//
//  Created by Norik on 20.09.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import XCTest

class CategoryScreen: Page {
    var app: XCUIApplication
    
    required init(app: XCUIApplication) {
        self.app = app
    }
    
    func tapCart() -> CartScreen {
        app.tabBars.buttons["Корзина"].tap()
        return CartScreen(app: app)
    }

}
