//
//  FeuilleControle_FFRSApp.swift
//  FeuilleControle_FFRS
//
//  Created by Guillaume Sylvain on 2025-01-21.
//

import SwiftUI

@main
struct FeuilleControle_FFRSApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
