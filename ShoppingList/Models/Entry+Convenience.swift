//
//  Entry+Convenience.swift
//  ShoppingList
//
//  Created by jdcorn on 11/15/19.
//  Copyright © 2019 jdcorn. All rights reserved.
//

import Foundation
import CoreData

extension Item {
    
    convenience init(itemName: String, isChecked: Bool = false, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.itemName = itemName
        self.isChecked = isChecked
    }
}
