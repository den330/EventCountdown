//
//  EventCountdownApp.swift
//  EventCountdown
//
//  Created by yaxin on 2024-06-18.
//

import SwiftUI
import SwiftData
import NotificationCenter

@main
struct EventCountdownApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
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

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}
