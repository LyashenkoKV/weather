//
//  WeatherData.swift
//  Weather
//
//  Created by Konstantin Lyashenko on 15.02.2023.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let id: Int
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let id: Int
    let description: String
}

