//
//  CityTableViewCell.swift
//  WeatherProject
//
//  Created by Konstantin Lyashenko on 18.04.2023.
//

import UIKit

final class CityTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubviews(to: self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureSubviews(to: self)
    }
    
    var cityCellLabel: UILabel! = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func configureSubviews(to view: UIView) {
        cityCellLabel.tintColor = .lightGray
        view.addSubview(cityCellLabel)
        NSLayoutConstraint.activate([
            cityCellLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cityCellLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            cityCellLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
    }
}
