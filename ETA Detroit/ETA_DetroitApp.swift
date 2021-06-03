//
//  ETA_DetroitApp.swift
//  ETA Detroit
//
//  Created by admin on 6/3/21.
//

import SwiftUI

@main
struct ETA_DetroitApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
