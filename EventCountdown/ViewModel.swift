//
//  ViewModel.swift
//  EventCountdown
//
//  Created by yaxin on 2024-06-19.
//

import Foundation
import SwiftData
import UserNotifications

class EventViewModel: ObservableObject {
    @Published var eventList: [Event]
    var modelContext: ModelContext
    var shouldNotify:Bool = false
    
    init(context: ModelContext) {
        self.modelContext = context
        try! eventList = context.fetch(FetchDescriptor<Event>())
    }

    var activeList: [Event] {
        eventList.filter{$0.getSecFromNow() >= 0}
    }
    func addEvent(name: String, date: Date) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        guard let year = components.year, let month = components.month, let day = components.day, let hour = components.hour, let minute = components.minute, let event = Event(name: name, year: year, month: month, day: day, hour: hour, minute: minute)  else {
            return
        }
        if event.getSecFromNow() <= 0 {
            return
        }
        modelContext.insert(event)
        eventList.append(event)
        if shouldNotify {
            scheduleNotification(event: event)
        }
    }
    
    func removeEvent(indexSet: IndexSet) {
        guard let index = indexSet.first else {
            return
        }
        let event = activeList[index]
        modelContext.delete(event)
        eventList = eventList.filter{ $0.id != event.id }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [event.id.uuidString])
    }
    
    func scheduleNotification(event: Event) {
        let content = UNMutableNotificationContent()
        content.title = "Incoming Activity Alert"
        content.body = "\(event.name) in less than 3 days!"
        content.sound = .default
        guard let triggerDate = Calendar.current.date(byAdding: .day, value: -3, to: event.date) else {
            return
        }
        let dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: triggerDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
        let request = UNNotificationRequest(identifier: event.id.uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("error scheduling notification \(error)")
            } else {
                print("Notification scheduled for three days before the event")
            }
        }
    }
}
