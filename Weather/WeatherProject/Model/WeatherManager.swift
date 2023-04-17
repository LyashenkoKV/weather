//
//  WeatherManager.swift
//  WeatherProject
//
//  Created by Konstantin Lyashenko on 15.02.2023.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&units=metric"
    let apiKeys = "appid=be25602c7b7109335d318474b9076526"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)&\(apiKeys)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(id: Int) {
        let urlString = "\(weatherURL)&id=\(id)&\(apiKeys)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)&\(apiKeys)"
        performRequest(with: urlString)
    }
    
    // MARK: - URLSession
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                DispatchQueue.main.async {
                    if let safeData = data {
                        if let weather = self.parseJSON(safeData) {
                            self.delegate?.didUpdateWeather(self, weather: weather)
                        }
                    }
                }
            }.resume()
        }
    }
    
    // MARK: - Parse JSON
    func parseJSON(_ weaterData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        
        do {
            let decodeData = try decoder.decode(WeatherData.self, from: weaterData)
            let conditionId = decodeData.weather[0].id
            let id = decodeData.id
            let temp = decodeData.main.temp
            let name = decodeData.name
            let timezone = decodeData.timezone
            let weather = WeatherModel(conditionId: conditionId, cityName: name, temperature: temp, id: id, timezone: timezone)
            return weather
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
