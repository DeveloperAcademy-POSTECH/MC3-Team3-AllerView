//
//  AllerViewApp.swift
//  AllerView
//
//  Created by 조기연 on 2023/07/10.
//

import CoreData
import SwiftUI

@main
struct AllerViewApp: App {
    let persistenceController = PersistenceController.shared
    

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
