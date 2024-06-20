//
//  ViewModel.swift
//  EventCountdown
//
//  Created by yaxin on 2024-06-19.
//

import Foundation
import SwiftData

class EventViewModel: ObservableObject {
    @Published var eventList: [Event]
    var modelContext: ModelContext
    
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
    }
    
    func removeEvent(indexSet: IndexSet) {
        guard let index = indexSet.first else {
            return
        }
        let event = activeList[index]
        modelContext.delete(event)
        eventList = eventList.filter{ $0.id != event.id }
    }
}
