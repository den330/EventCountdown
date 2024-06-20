//
//  EventCountdownApp.swift
//  EventCountdown
//
//  Created by yaxin on 2024-06-18.
//

import SwiftUI
import SwiftData

@main
struct EventCountdownApp: App {
    let container: ModelContainer
    var body: some Scene {
        WindowGroup {
            ContentView(modelContext: container.mainContext)
        }.modelContainer(container)
    }
    init() {
        do {
            container = try ModelContainer(for: Event.self)
        } catch {
            fatalError()
        }
    }
}
