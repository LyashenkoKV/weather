//
//  WeatherTableViewCell.swift
//  Weather
//
//  Created by Konstantin Lyashenko on 14.02.2023.
//

import UIKit

final class WeatherCollectionViewCell: CollectionViewCell {
    
    private var data: DataModel?
    private var weatherManager: WeatherManager?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        super.configureSubviews(to: self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        super.configureSubviews(to: self)
    }
    
    func configure(_ data: DataModel) {
        self.data = data
        let city = data.name
        let id = data.id
        super.cityNameLabel.text = city
        weatherManager = WeatherManager()
        weatherManager?.delegate = self
        weatherManager?.fetchWeather(with: .byCityID(id))
        
        super.deleteCellButton.addTarget(self, action: #selector(deleteCellButtonAction), for: .touchUpInside)
        super.deleteCellButton.isHidden = true
    }
    
    @objc func deleteCellButtonAction() {
        super.delegate?.deleteCell(self)
    }
}

// MARK: - WeatherManagerDelegate
extension WeatherCollectionViewCell: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            super.tempLabel.text = weather.temperatureString
            super.weatherImageView.image = UIImage(systemName: weather.conditionName)
            TimeManager.shared.startUpdatingTime(forLabel: super.timeLabel, timeZoneOffset: weather.timezone)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error.localizedDescription)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        TimeManager.shared.stopUpdatingTime(forLabel: super.timeLabel)
    }
}

