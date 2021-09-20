//
//  PurchaseViewControllerSnapshotTest.swift
//  BlackStarShop_V2UITests
//
//  Created by Norik on 19.09.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import XCTest
import SnapshotTesting
@testable import BlackStarShop_V2

class PurchaseViewControllerSnapshotTest: XCTestCase {
    
    var sut: PurchaseViewController!
    
    override func setUp() {
        super.setUp()
        sut = PurchaseViewController()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testExample() {
        assertSnapshot(matching: sut, as: .image(on: .iPhone8))
    }

}
