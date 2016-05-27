//
//  Grocery Controller.swift
//  ShoppingList
//
//  Created by Tyler on 5/27/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import Foundation
import CoreData

class GroceryController {
    
    static let sharedController = GroceryController()
    
    var fetchedResultsController: NSFetchedResultsController
    
    init() {
        let request = NSFetchRequest(entityName: "Groceries")
        let request2 = NSSortDescriptor(key: "didGet", ascending: false)
        request.sortDescriptors = [request2]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: Stack.sharedStack.managedObjectContext, sectionNameKeyPath: "didGet", cacheName: nil)
        _ = try? fetchedResultsController.performFetch()
        
    }
    
    // MARK: - Method Signatures
    // CRUD
    
    func addItem(item: String) {
        _ = Groceries(item: item)
        saveToPersistentStorage()
    }
    
    func deleteItem(groceryItem: Groceries) {
        let moc = Stack.sharedStack.managedObjectContext
        moc.deleteObject(groceryItem)
        saveToPersistentStorage()
    }
    
    
    // MARK: - Persistence 
    
    func saveToPersistentStorage() {
        let moc = Stack.sharedStack.managedObjectContext
        do {
            try moc.save()
        } catch {
            print("Unable to save item")
        }
    }
}