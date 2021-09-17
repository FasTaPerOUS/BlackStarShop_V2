//
//  DataStoreManager.swift
//  BlackStarShop_V2
//
//  Created by Norik on 17.09.2021.
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
    func updateQuantityOfItem(name: String, color: String, size: String) {
        //получаем нужный товар по критериям и уменьшаем его количество
        fetchRequest.predicate = NSPredicate(format: "name = %@ AND colorName =%@ AND #size = %@", name, color, size)
        let items = getItems()
        fetchRequest.predicate = nil
        guard let itemForChange = items.first else {
            return
        }
        itemForChange.quantity -= 1
        saveContext()
    }
    
    //добавляется только когда выбираешь размер
    func addItem(item: OneItemWithAllColors, index: Int, size: String) {
        //добавляю фильтр для получения товаров: совпадение по имени, цвету и размеру
        //либо получу массив из 1 элемента, либо пустой массив
        fetchRequest.predicate = NSPredicate(format: "name = %@ AND colorName =%@ AND #size = %@", item.name, item.colorName[index], size)
        let items = getItems()
        fetchRequest.predicate = nil
        //проверка на наличие первого элемента
        guard let itemForChange = items.first else {
            //создаем новый элемент и сохраняем его
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
            return
        }
        //делаем +1 к количеству и сохраняем
        itemForChange.quantity += 1
        saveContext()
    }
    
    func deleteItem(name: String, color: String, size: String) {
        //получаем нужный товар по критериям и удаляем его
        fetchRequest.predicate = NSPredicate(format: "name = %@ AND colorName =%@ AND #size = %@", name, color, size)
        let _ = getItems().map {
            viewContext.delete($0)
        }
        fetchRequest.predicate = nil
        saveContext()
    }
}
