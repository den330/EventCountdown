//
//  ViewModel.swift
//  EventCountdown
//
//  Created by yaxin on 2024-06-19.
//

import Foundation

class EventViewModel: ObservableObject {
    @Published var eventList: [Event] = [];
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
        eventList.append(event)
    }
    
    func removeEvent(indexSet: IndexSet) {
        guard let index = indexSet.first else {
            return
        }
        let event = activeList[index]
        eventList = eventList.filter{ $0.id != event.id }
    }
}
