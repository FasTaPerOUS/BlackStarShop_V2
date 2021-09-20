//
//  CartScreen.swift
//  BlackStarShop_V2UITests
//
//  Created by Norik on 20.09.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import XCTest

struct CartScreen: Page {
    var app: XCUIApplication
    
    init(app: XCUIApplication) {
        self.app = app
    }
    
    func tapPurchaseButton() -> Self {
        app.buttons[" Оформить заказ "].tap()
        return self
    }
    
    func emptyCartAlertExist() {
        XCTAssertFalse(app.alerts["Пустая корзина"].exists)
    }
    
    func tapPurchaseButtonAndGoToPurchaseScreen() -> PurchaseScreen {
        app.buttons[" Оформить заказ "].tap()
        return PurchaseScreen(app: app)
    }
    
    
}
