//
//  AllerViewApp.swift
//  AllerView
//
//  Created by 조기연 on 2023/07/10.
//

import SwiftUI
import CoreData

@main
struct AllerViewApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            AllergySearchView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            // MARK: - init data at firstLaunch
                .onAppear(){
                    let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
                    if !launchedBefore {
                        print("firstLoad!")
                        UserDefaults.standard.set(true, forKey: "launchedBefore")
                        let managedContext = persistenceController.container.viewContext
                        managedContext.createUser(name: "user")
                    } else {
                        fetchData()
                    }
                }
        }
    }
    private func fetchData() {
        let managedContext = persistenceController.container.viewContext
        let keywordFetchReq: NSFetchRequest<Keyword> = Keyword.fetchRequest()
        do {
            let keywords = try managedContext.fetch(keywordFetchReq)
            for keyword in keywords {
                print("User added keyword: \(keyword.name ?? "Unknown")")
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
}
