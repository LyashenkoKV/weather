//
//  City.swift
//  WeatherProject
//
//  Created by Konstantin Lyashenko on 17.04.2023.
//

import Foundation
import CoreLocation

struct City: Codable {
    let name: String
    let lat: Double
    let lon: Double
    let country: String
    let state: String?
}
