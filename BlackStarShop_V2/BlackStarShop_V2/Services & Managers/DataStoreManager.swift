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
    
    // MARK: - Core Data Saving

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
    
    //MARK: - Core Data Getting
    
    func getItems() -> [ItemCD] {
        guard let items = try? viewContext.fetch(fetchRequest) else {
            print("Problem in \(#file), \(#function)")
            return []
        }
        return items
    }
    
    //MARK: - Core Data Changing
    
    func removeItems() {
        let deleteRequest = NSBatchDeleteRequest(fetchRequest:
            NSFetchRequest(entityName: "ItemCD"))
        do {
            try viewContext.execute(deleteRequest)
            saveContext()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    //используется только когда жмешь на минусовую кнопку в корзине в ячейке
    func updateQuantityOfItem(index: Int) {
        guard let items = try? viewContext.fetch(fetchRequest) else {
            print("Problem in \(#file), \(#function)")
            return
        }
        items[index].quantity -= 1
        if items[index].quantity == 0 {
            viewContext.delete(items[index])
        }
        saveContext()
    }
    
    //добавляется только когда выбираешь размер
    func addItem(item: OneItemWithAllColors, index: Int, size: String) {
        //получаю массив товаров
        let items = getItems()
        print("Вызван метод добавления товара в корзину")
        //проходимся по каждому товару, если есть совпадения по имени, цвету и размеру
        //то делаем +1 к количесту, сохраняем и завершаем функцию
        for el in items {
            if el.name == item.name && el.colorName == item.colorName[index]
                && el.size == size {
                print("До увеличения счетчика и сохранения")
                print(items.map({ $0.quantity }))
                el.quantity += 1
                saveContext()
                print("После увеличения счетчика и сохранения")
                print(getItems().map({ $0.quantity }))
                return
            }
        }
        //добавляем ПОЛНОСТЬЮ новый товар и сохраняем его
        let newItem = ItemCD(context: viewContext)
        newItem.colorName = item.colorName[index]
        newItem.name = item.name
        newItem.quantity = 1
        newItem.size = size
        newItem.mainImageURL = item.mainImage[index]
        newItem.currPrice = Int32(item.price[index]) ?? -1
        newItem.oldPrice = Int32(item.oldPrice[index]) ?? -1
        newItem.tag = item.tag[index]
        newItem.descript = item.description
        newItem.productImagesURL = item.productImages[index].map {
            return $0.imageURL
        }
        saveContext()
    }
    
    func deleteItem(at index: Int) {
        let items = getItems()
        viewContext.delete(items[index])
        saveContext()
    }
}
