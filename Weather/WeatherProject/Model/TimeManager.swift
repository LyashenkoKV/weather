//
//  TimeManageger.swift
//  WeatherProject
//
//  Created by Konstantin Lyashenko on 07.04.2023.
//

import Foundation

final class TimeManager {
    static let shared = TimeManager()
    
    func timeZoneString(timeZone: Int) -> String {
        let currentDate = Date()
        let timezoneOffsetSeconds = TimeZone.current.secondsFromGMT()
        let timezoneOffSet = TimeInterval(timeZone - timezoneOffsetSeconds)
        let timeZoneDate = currentDate.addingTimeInterval(timezoneOffSet)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let formattedDate = dateFormatter.string(from: timeZoneDate)
        
        return "\(formattedDate)"
    }
}
