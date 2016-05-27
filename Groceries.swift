//
//  Groceries.swift
//  ShoppingList
//
//  Created by Tyler on 5/27/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import Foundation
import CoreData


class Groceries: NSManagedObject {

    convenience init?(item: String, didGet: Bool = false, context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        
        guard let entity = NSEntityDescription.entityForName("Groceries", inManagedObjectContext: context) else { return nil }
        
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.item = item
        self.didGet = didGet
    }

}
