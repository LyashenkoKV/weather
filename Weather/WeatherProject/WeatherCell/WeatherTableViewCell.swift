//
//  WeatherTableViewCell.swift
//  Weather
//
//  Created by Konstantin Lyashenko on 14.02.2023.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    
    private var data: DataModel?
    private var weatherManager: WeatherManager?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
    }

    func configure(_ data: DataModel) {
        self.data = data
        let city = data.name
        let id = data.id
        cityNameLabel.text = city
        
        weatherManager = WeatherManager()
        weatherManager?.delegate = self
        weatherManager?.fetchWeather(id: id)
    }
}

// MARK: - WeatherManagerDelegate
extension WeatherTableViewCell: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.tempLabel.text = weather.temperatureString
            self.weatherImage.image = UIImage(systemName: weather.conditionName)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error.localizedDescription)
    }
}
