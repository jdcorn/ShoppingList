//
//  ItemController.swift
//  ShoppingList
//
//  Created by jdcorn on 11/15/19.
//  Copyright © 2019 jdcorn. All rights reserved.
//

import Foundation
import CoreData

class ItemController {
    
    // MARK: - Properites
    static let sharedInstance = ItemController()
    
    // MARK: - Source of Truth
    var fetchedResultsController: NSFetchedResultsController<Item>
    init() {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "itemName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController = resultsController
        
        do{
            try fetchedResultsController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - CRUD
    func create(itemName: String) {
        _ = Item(itemName: itemName)
        saveToPersistentStore()
        
    }
    
    func update(item: Item, itemName: String) {
        item.itemName = itemName
        saveToPersistentStore()
        
    }
    
    func delete(item: Item) {
        CoreDataStack.context.delete(item)
        saveToPersistentStore()
    }
    
    // MARK: - Persistence
    func saveToPersistentStore() {
        if CoreDataStack.context.hasChanges {
            try? CoreDataStack.context.save()
        }
    }
} // Class end
