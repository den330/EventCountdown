//
//  Util.swift
//  EventCountdown
//
//  Created by yaxin on 2024-06-19.
//

import Foundation

struct Util {
    private init() {}
    public static func convertSecondsToComponents(timeInSec: Int) -> (Int, Int, Int, Int) {
        let sec = timeInSec % 60
        let min = timeInSec / 60 % 60
        let hour = timeInSec / 3600 % 24
        let day = timeInSec / (3600 * 24)
        return (day, hour, min, sec)
    }
}

extension Date {
    func convertToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.string(from: self)
    }
}
