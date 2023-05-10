//
//  WeatherManager.swift
//  WeatherProject
//
//  Created by Konstantin Lyashenko on 15.02.2023.
//

import Foundation
import CoreLocation
// MARK: - Protocol
protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}
// MARK: - Enum WeatherRequestType
enum WeatherRequestType {
    case byCityName(String)
    case byCityID(Int)
    case byCoordinates(CLLocationDegrees, CLLocationDegrees)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(with requestType: WeatherRequestType) {
        var components = URLComponents(string: weatherURL)!
        var queryItems = [URLQueryItem]()
        
        if let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
               let config = NSDictionary(contentsOfFile: path),
           let apiKey = config["apiKey"] as? String {

            switch requestType {
            case .byCityName(let cityName):
                queryItems.append(URLQueryItem(name: "q", value: cityName))
            case .byCityID(let cityID):
                queryItems.append(URLQueryItem(name: "id", value: "\(cityID)"))
            case .byCoordinates(let latitude, let longitude):
                queryItems.append(URLQueryItem(name: "lat", value: "\(latitude)"))
                queryItems.append(URLQueryItem(name: "lon", value: "\(longitude)"))
            }
            queryItems.append(URLQueryItem(name: "units", value: "metric"))
            queryItems.append(URLQueryItem(name: "appid", value: apiKey))
            components.queryItems = queryItems
            performRequest(with: components.url!.absoluteString)
        }
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
            let decodeData = try decoder.decode(WeatherDataModel.self, from: weaterData)
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
