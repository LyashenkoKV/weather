//
//  WeatherTableViewCell.swift
//  Weather
//
//  Created by Konstantin Lyashenko on 14.02.2023.
//

import UIKit
// MARK: - Protocol
protocol WeatherCollectionViewCellDelegate: AnyObject {
    func deleteCell(_ cell: WeatherCollectionViewCell)
}

final class WeatherCollectionViewCell: UICollectionViewCell {
    
    private var data: DataModel?
    private var weatherManager: WeatherManager?
    
    var delegate: WeatherCollectionViewCellDelegate?
    
    let color = UIColor(red: 27/255, green: 67/255, blue: 72/255, alpha: 1)
    
    let cityNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tempLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let degreeLabel: UILabel = {
        let label = UILabel()
        label.text = "°"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let unitLabel: UILabel = {
        let label = UILabel()
        label.text = "C"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .left
        return label
    }()
    
    let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .right
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let deleteCellButton: UIButton = {
        let button = UIButton(type: .close)
        button.contentMode = .right
        button.setBackgroundImage(UIImage(), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        weatherImageView.tintColor = color
        unitLabel.textColor = color
        degreeLabel.textColor = color
        tempLabel.textColor = color
        timeLabel.textColor = color
        cityNameLabel.textColor = color
        
        addSubview(cityNameLabel)
        addSubview(timeLabel)
        addSubview(tempLabel)
        addSubview(degreeLabel)
        addSubview(unitLabel)
        addSubview(weatherImageView)
        addSubview(deleteCellButton)
        
        NSLayoutConstraint.activate([
            cityNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            cityNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            cityNameLabel.trailingAnchor.constraint(equalTo: weatherImageView.leadingAnchor, constant: -10),
            
            timeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            timeLabel.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor, constant: 5),
            
            tempLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            tempLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 5),
            
            degreeLabel.leadingAnchor.constraint(equalTo: tempLabel.trailingAnchor, constant: 5),
            degreeLabel.centerYAnchor.constraint(equalTo: tempLabel.centerYAnchor),
            
            unitLabel.leadingAnchor.constraint(equalTo: degreeLabel.trailingAnchor, constant: 5),
            unitLabel.centerYAnchor.constraint(equalTo: tempLabel.centerYAnchor),
            
            weatherImageView.leadingAnchor.constraint(equalTo: cityNameLabel.trailingAnchor),
            weatherImageView.centerYAnchor.constraint(equalTo: cityNameLabel.centerYAnchor),
            
            deleteCellButton.topAnchor.constraint(equalTo: topAnchor, constant: 25),
            deleteCellButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            deleteCellButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25),
        ])
        
    }
    
    func configure(_ data: DataModel) {
        self.data = data
        let city = data.name
        let id = data.id
        cityNameLabel.text = city
        weatherManager = WeatherManager()
        weatherManager?.delegate = self
        weatherManager?.fetchWeather(with: .byCityID(id))
        
        deleteCellButton.addTarget(self, action: #selector(deleteCellButtonAction), for: .touchUpInside)
        deleteCellButton.isHidden = true
    }
    
    @objc func deleteCellButtonAction() {
        delegate?.deleteCell(self)
    }
}

// MARK: - WeatherManagerDelegate
extension WeatherCollectionViewCell: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.tempLabel.text = weather.temperatureString
            self.weatherImageView.image = UIImage(systemName: weather.conditionName)
            TimeManager.shared.startUpdatingTime(forLabel: self.timeLabel, timeZoneOffset: weather.timezone)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error.localizedDescription)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        TimeManager.shared.stopUpdatingTime(forLabel: self.timeLabel)
    }
}

