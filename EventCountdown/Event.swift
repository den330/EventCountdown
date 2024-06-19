//
//  Event.swift
//  EventCountdown
//
//  Created by yaxin on 2024-06-19.
//

import Foundation

class Event: Identifiable {
    var id = UUID()
    var date: Date
    var name: String

    init(date: Date, name: String) {
        self.date = date
        self.name = name
    }
    convenience init?(name: String, year: Int, month: Int, day: Int, hour: Int, minute: Int) {
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        let date = calendar.date(from: components)
        guard let date = date else {
            return nil
        }
        self.init(date: date, name: name)
    }
    
    func getSecFromNow() -> Int {
        let now = Date.now
        let distance = now.distance(to: self.date)
        return Int(distance)
    }
}
