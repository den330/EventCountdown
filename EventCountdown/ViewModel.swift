//
//  ViewModel.swift
//  EventCountdown
//
//  Created by yaxin on 2024-06-19.
//

import Foundation

class EventViewModel: ObservableObject {
    @Published var eventList: [Event] = [];
    func addEvent(name: String, year: Int, month: Int, day: Int, hour: Int, minute: Int) {
        guard let event = Event(name: name, year: year, month: month, day: day, hour: hour, minute: minute) else {
            return
        }
        eventList.append(event)
    }
    
    func removeEvent(id: UUID) {
        eventList = eventList.filter{ $0.id != id }
    }
}
