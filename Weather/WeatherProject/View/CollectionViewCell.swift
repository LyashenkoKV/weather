//
//  CollectionViewCell.swift
//  WeatherProject
//
//  Created by Konstantin Lyashenko on 04.05.2023.
//

import UIKit

protocol WeatherCollectionViewCellDelegate: AnyObject {
    func deleteCell(_ cell: CollectionViewCell)
}

class CollectionViewCell: UICollectionViewCell {

    var delegate: WeatherCollectionViewCellDelegate?
    
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
    
    func configureSubviews(to view: UIView) {
        weatherImageView.tintColor = myTintColor
        unitLabel.textColor = myTintColor
        degreeLabel.textColor = myTintColor
        tempLabel.textColor = myTintColor
        timeLabel.textColor = myTintColor
        cityNameLabel.textColor = myTintColor
        
        view.addSubview(cityNameLabel)
        view.addSubview(timeLabel)
        view.addSubview(tempLabel)
        view.addSubview(degreeLabel)
        view.addSubview(unitLabel)
        view.addSubview(weatherImageView)
        view.addSubview(deleteCellButton)
        
        NSLayoutConstraint.activate([
            cityNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            cityNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            cityNameLabel.trailingAnchor.constraint(equalTo: weatherImageView.leadingAnchor, constant: -10),
            
            timeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            timeLabel.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor, constant: 5),
            
            tempLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            tempLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 5),
            
            degreeLabel.leadingAnchor.constraint(equalTo: tempLabel.trailingAnchor, constant: 5),
            degreeLabel.centerYAnchor.constraint(equalTo: tempLabel.centerYAnchor),
            
            unitLabel.leadingAnchor.constraint(equalTo: degreeLabel.trailingAnchor, constant: 5),
            unitLabel.centerYAnchor.constraint(equalTo: tempLabel.centerYAnchor),
            
            weatherImageView.leadingAnchor.constraint(equalTo: cityNameLabel.trailingAnchor),
            weatherImageView.centerYAnchor.constraint(equalTo: cityNameLabel.centerYAnchor),
            
            deleteCellButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 25),
            deleteCellButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            deleteCellButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25),
        ])
    }
}
