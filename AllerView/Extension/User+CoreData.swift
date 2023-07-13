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
    
    func addAllergy(_ allergy: Allergy) {
        self.addToAllergies(allergy)
        viewContext.saveChanges()
    }
    
    func addAllergies(_ allergies: [Allergy]) {
        for allergy in allergies {
            self.addToAllergies(allergy)
        }
        viewContext.saveChanges()
    }
    
    func addAllergies(_ allergies: NSSet) {
        self.addToAllergies(allergies)
        viewContext.saveChanges()
    }
    
    // MARK: - remove
    
    func removeAllergy(_ allergy: Allergy) {
        self.removeFromAllergies(allergy)
        viewContext.saveChanges()
    }
    
    func removeAllergies(_ allergies: [Allergy]) {
        for allergy in allergies {
            self.removeFromAllergies(allergy)
        }
        viewContext.saveChanges()
    }
    
    func removeAllergies(_ allergies: NSSet) {
        self.removeFromAllergies(allergies)
        viewContext.saveChanges()
    }
    
    // MARK: - delete
    
    func delete() {
        viewContext.delete(self)
        viewContext.saveChanges()
    }
}
