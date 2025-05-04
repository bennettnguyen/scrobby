//
//  scrobbyApp.swift
//  scrobby
//
//  Created by Bennett Nguyen on 3/28/25.
//

import SwiftUI
import SwiftData

@main
struct scrobbyApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Scrobble.self,
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    let serviceContainer: ServiceContainer

    init() {
        self.serviceContainer = ServiceContainer(
            modelContext: sharedModelContainer.mainContext
        )
        BackgroundTaskManager.shared.registerBackgroundTasks()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(serviceContainer)
                .onAppear {
                    BackgroundTaskManager.shared.scheduleBackgroundScrobble()
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
