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
    
    func createUser(name: String, keywords: [Keyword] = []) {
        let user = User(context: self)
        user.id = UUID()
        user.name = name
        for keyword in keywords {
            user.addToKeywords(keyword)
        }
        self.saveChanges()
    }
    
    func createKeyword(name: String, user: User?) {
        let keyword = Keyword(context: self)
        keyword.id = UUID()
        keyword.name = name
        keyword.user = user
        self.saveChanges()
    }
}
