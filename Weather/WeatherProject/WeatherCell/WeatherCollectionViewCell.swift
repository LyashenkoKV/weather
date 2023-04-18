//
//  WeatherTableViewCell.swift
//  Weather
//
//  Created by Konstantin Lyashenko on 14.02.2023.
//

import UIKit

protocol WeatherCollectionViewCellDelegate: AnyObject {
    func deleteCell(_ cell: WeatherCollectionViewCell)
}

final class WeatherCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var deleteCellButton: UIButton!
    
    private var data: DataModel?
    private var weatherManager: WeatherManager?
    private var timer: Timer?
    
    var delegate: WeatherCollectionViewCellDelegate?
    
    func configure(_ data: DataModel) {
        self.data = data
        let city = data.name
        let id = data.id
        cityNameLabel.text = city
        weatherManager = WeatherManager()
        weatherManager?.delegate = self
        weatherManager?.fetchWeather(with: .byCityID(id))
    }
    
    @IBAction func deleteCellButtonAction(_ sender: UIButton) {
        delegate?.deleteCell(self)
    }
}

// MARK: - WeatherManagerDelegate
extension WeatherCollectionViewCell: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        timer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { _ in
            self.timeLabel.text = weather.timeZoneString
        }
        
        DispatchQueue.main.async {
            self.tempLabel.text = weather.temperatureString
            self.weatherImage.image = UIImage(systemName: weather.conditionName)
            self.timeLabel.text = weather.timeZoneString

            RunLoop.current.add(self.timer!, forMode: .common)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error.localizedDescription)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        timer?.invalidate()
        timer = nil
    }
}

