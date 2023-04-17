//
//  WeatherModel.swift
//  WeatherProject
//
//  Created by Konstantin Lyashenko on 15.02.2023.
//

import Foundation

@objcMembers
final class WeatherModel: NSObject {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    let id: Int
    let timezone: Int
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    var timeZoneString: String {
        TimeManager.shared.timeZoneString(timeZone: timezone)
    }
    
    init(conditionId: Int, cityName: String, temperature: Double, id: Int, timezone: Int) {
            self.conditionId = conditionId
            self.cityName = cityName
            self.temperature = temperature
            self.id = id
            self.timezone = timezone
        }
    
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.sun"
        default:
            return "cloud"
        }
    }
}
