//
//  Keyword+CoreData.swift
//  AllerView
//
//  Created by 조기연 on 2023/07/12.
//

import Foundation
import CoreData

extension Keyword {
    
    var viewContext: NSManagedObjectContext {
        return PersistenceController.shared.container.viewContext
    }
    
    func changeName(name: String) {
        self.name = name
        viewContext.saveChanges()
    }
    
    func delete() {
        viewContext.delete(self)
        viewContext.saveChanges()
    }
}
