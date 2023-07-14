//
//  Ext+User.swift
//  AllerView
//
//  Created by 조기연 on 2023/07/12.
//

import Foundation
import CoreData

extension User {
        
    var viewContext: NSManagedObjectContext {
        return PersistenceController.shared.container.viewContext
    }
    
    // MARK: - change
    
    func changeName(name: String) {
        self.name = name
        viewContext.saveChanges()
    }
    
    // MARK: - add
    
    func addKeyword(_ keyword: Keyword) {
        self.addToKeywords(keyword)
        viewContext.saveChanges()
    }
    
    func addKeywords(_ keywords: [Keyword]) {
        for keyword in keywords {
            self.addToKeywords(keyword)
        }
        viewContext.saveChanges()
    }
    
    func addKeywords(_ keywords: NSSet) {
        self.addToKeywords(keywords)
        viewContext.saveChanges()
    }
    
    // MARK: - remove
    
    func removeKeyword(_ keyword: Keyword) {
        self.removeFromKeywords(keyword)
        viewContext.saveChanges()
    }
    
    func removeKeywords(_ keywords: [Keyword]) {
        for keyword in keywords {
            self.removeFromKeywords(keyword)
        }
        viewContext.saveChanges()
    }
    
    func removeKeywords(_ keywords: NSSet) {
        self.removeFromKeywords(keywords)
        viewContext.saveChanges()
    }
    
    // MARK: - delete
    
    func delete() {
        viewContext.delete(self)
        viewContext.saveChanges()
    }
}
