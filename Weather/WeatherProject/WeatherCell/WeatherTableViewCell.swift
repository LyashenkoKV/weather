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

    func configure(_ data: DataModel) {
        self.data = data
        cityNameLabel.text = data.name
        tempLabel.text = data.temp
        weatherImage.image = UIImage(systemName: data.conditionName)
    }
}

