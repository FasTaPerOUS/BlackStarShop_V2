//
//  ItemCD+CoreDataProperties.swift
//  BlackStarShop_V2
//
//  Created by Norik on 17.09.2021.
//  Copyright © 2021 Norik. All rights reserved.
//
//

import Foundation
import CoreData


extension ItemCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemCD> {
        return NSFetchRequest<ItemCD>(entityName: "ItemCD")
    }

    @NSManaged public var colorName: String?
    @NSManaged public var currPrice: Int32
    @NSManaged public var descript: String?
    @NSManaged public var mainImageURL: String?
    @NSManaged public var name: String?
    @NSManaged public var oldPrice: Int32
    @NSManaged public var productImagesURL: [String]?
    @NSManaged public var quantity: Int32
    @NSManaged public var size: String?
    @NSManaged public var tag: String?

}
