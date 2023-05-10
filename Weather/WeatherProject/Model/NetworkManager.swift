//
//  NetworkManager.swift
//  WeatherProject
//
//  Created by Konstantin Lyashenko on 17.04.2023.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    private let session = URLSession.shared
    
    func fetchCities(for query: String, completion: @escaping (Result<[CityModel], Error>) -> Void) {
        let endpoint = "https://api.openweathermap.org/geo/1.0/direct"

        if let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
               let config = NSDictionary(contentsOfFile: path),
           let apiKey = config["apiKey"] as? String {
            let params = [
                "q": query,
                "limit": "10",
                "appid": apiKey
            ]
            var components = URLComponents(string: endpoint)!
            components.queryItems = params.map { key, value in
                URLQueryItem(name: key, value: value)
            }
            let url = components.url!
            let task = session.dataTask(with: url) { data, response, error in
                guard let data = data else {
                    let error = NSError(domain: "WeatherApp", code: -1, userInfo: nil)
                    completion(.failure(error))
                    return
                }
                do {
                    let cities = try self.parseJSON(data: data)
                    completion(.success(cities))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    private func parseJSON(data: Data) throws -> [CityModel] {
        let decoder = JSONDecoder()
        let cities = try decoder.decode([CityModel].self, from: data)
        return cities
    }
}
