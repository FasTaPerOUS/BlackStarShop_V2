//
//  DataStoreManager.swift
//  BlackStarShop_V2
//
//  Created by Norik on 08.09.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import Foundation
import CoreData

class DataStoreManager {
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ItemCD")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    lazy var viewContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    lazy var fetchRequest: NSFetchRequest<ItemCD> = {
        return ItemCD.fetchRequest()
    }()
    
    // MARK: - Core Data Saving support

    func saveContext () {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func getItems() -> [ItemCD] {
        guard let items = try? viewContext.fetch(fetchRequest) else {
            print("Problem in \(#file), \(#function)")
            return []
        }
        return items
    }
    
    func removeItems() {
        let deleteRequest = NSBatchDeleteRequest(fetchRequest:
            NSFetchRequest(entityName: "ItemCD"))
        do {
            try viewContext.execute(deleteRequest)
            try viewContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func updateQuantityOfItem(index: Int) {
        guard let items = try? viewContext.fetch(fetchRequest) else {
            print("Problem in \(#file), \(#function)")
            return
        }
        items[index].quantity -= 1
        if items[index].quantity == 0 {
            viewContext.delete(items[index])
        }
        do {
            try viewContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func addItem(item: OneItemWithAllColors, index: Int, size: String) {
        let items = getItems()
        for el in items {
            if el.name == item.name && el.colorName == item.colorName[index]
                && el.size == size {
                el.quantity += 1
                do {
                    try viewContext.save()
                    return
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
        let newItem = ItemCD(context: viewContext)
        newItem.colorName = item.colorName[index]
        newItem.name = item.name
        newItem.quantity = 1
        newItem.size = size
        newItem.mainImageURL = item.mainImage[index]
        newItem.currPrice = Int16(item.price[index]) ?? -1
        newItem.oldPrice = Int16(item.oldPrice[index]) ?? -1
        newItem.tag = item.tag[index]
        newItem.descript = item.description
        var s = [String]()
        for el in item.productImages[index] {
            s.append(el.imageURL)
        }
        newItem.productImagesURL = s
        do {
            try viewContext.save()
            return
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func deleteItem(at index: Int) {
        let items = getItems()
        viewContext.delete(items[index])
        saveContext()
    }
}
