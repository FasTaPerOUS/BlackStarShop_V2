//
//  PurchaseScreen.swift
//  BlackStarShop_V2UITests
//
//  Created by Norik on 20.09.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import XCTest

class PurchaseScreen: Page {
    var app: XCUIApplication
    
    lazy var elementsQuery: XCUIElementQuery = {
        self.app.scrollViews.otherElements
    }()
    
    required init(app: XCUIApplication) {
        self.app = app
    }
    
    func scrollToBottom() -> Self {
        app.swipeUp()
        return self
    }
    
    func tapPurchaseButton() -> Self {
        app.buttons[" Подтвердить заказ "].tap()
        return self
    }
    
    func sberTopAlertIsExist() {
        XCTAssertTrue(app.alerts["Сбер топ!"].exists)
    }
    
}
