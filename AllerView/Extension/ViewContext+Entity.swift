//
//  ViewContext+Utils.swift
//  AllerView
//
//  Created by 조기연 on 2023/07/12.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    
    func saveChanges() {
        if !self.hasChanges {
            return
        }
        
        do {
            try self.save()
        } catch {
            print("Could not save changes to Core Data ::: ", error.localizedDescription)
        }
    }
    
    func createUser(name: String, allergies: [Allergy] = []) {
        let user = User(context: self)
        user.id = UUID()
        user.name = name
        for allergy in allergies {
            user.addToAllergies(allergy)
        }
        self.saveChanges()
    }
    
    func createAllergy(name: String, user: User, keywords: [Keyword] = []) {
        let allergy = Allergy(context: self)
        allergy.id = UUID()
        allergy.name = name
        allergy.user = user
        for keyword in keywords {
            allergy.addToKeywords(keyword)
        }
        self.saveChanges()
    }
    
    func createKeyword(name: String, allergy: Allergy) {
        let keyword = Keyword(context: self)
        keyword.id = UUID()
        keyword.allergy = allergy
        self.saveChanges()
    }
}
