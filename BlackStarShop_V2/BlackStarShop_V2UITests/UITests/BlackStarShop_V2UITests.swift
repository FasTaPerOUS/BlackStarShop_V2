//
//  BlackStarShop_V2UITests.swift
//  BlackStarShop_V2UITests
//
//  Created by Norik on 19.09.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import XCTest
import SnapshotTesting

class BlackStarShop_V2UITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDown() {
        app = nil
    }

    func testExample() {
        
        CategoryScreen(app: app)
            .tapCart()
            .tapPurchaseButton()
            .emptyCartAlertExist()
    }
    
    func testSberTopIsExist() {
        CategoryScreen(app: app)
            .tapCart()
            .tapPurchaseButtonAndGoToPurchaseScreen()
            .scrollToBottom()
            .tapPurchaseButton()
            .sberTopAlertIsExist()
    }
}
