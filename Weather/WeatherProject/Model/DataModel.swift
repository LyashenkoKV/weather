//
//  DataModel.swift
//  WeatherProject
//
//  Created by Konstantin Lyashenko on 16.02.2023.
//

import Foundation

struct DataModel: Codable {
    var name: String
    var temp: String
    var conditionName: String

}

extension DataModel {
    static let userDefaultsKey = "DefaultKey"
    
    static func save(_ data: [DataModel]) {
        let data = try? JSONEncoder().encode(data)
        UserDefaults.standard.set(data, forKey: userDefaultsKey)
    }
    
    static func loadData() -> [DataModel] {
        var returnValue: [DataModel] = []
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let datas = try? JSONDecoder().decode([DataModel].self, from: data) {
            returnValue = datas
        }
        return returnValue
    }
}
