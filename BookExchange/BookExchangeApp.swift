//
//  BookExchangeApp.swift
//  BookExchange
//
//  Created by Oleg Koptev on 26.12.2020.
//

import SwiftUI
import CoreData

@main
struct BookExchangeApp: App {
    @Environment(\.scenePhase) var scenePhase
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AppContext())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .onChange(of: scenePhase) { _ in
            persistenceController.save()
        }
    }
}
