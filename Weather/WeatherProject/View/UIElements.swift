//
//  UIElements.swift
//  WeatherProject
//
//  Created by Konstantin Lyashenko on 25.04.2023.
//

import UIKit

struct MyViewControllerUI {
    
    var allConstraints: [NSLayoutConstraint] {
        return [
            portraitConstraints,
            portraitUpsideDownConstraints,
            landscapeLeftConstraints,
            landscapeRightConstraints
        ].flatMap { $0 }
    }
    
    var portraitConstraints: [NSLayoutConstraint] = []
    var portraitUpsideDownConstraints: [NSLayoutConstraint] = []
    var landscapeLeftConstraints: [NSLayoutConstraint] = []
    var landscapeRightConstraints: [NSLayoutConstraint] = []
    
    let generalStackView = UIStackView()
    let searchStackView = UIStackView()
    let tempStackView = UIStackView()
    let currentLocationButton = UIButton()
    let searchBar = UISearchBar()
    let addButton = UIButton()
    let imageView = UIImageView()
    let degreeLabel = UILabel()
    let iconDegreeLabel = UILabel()
    let celsiusLabel = UILabel()
    let cityNameLabel = UILabel()
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let cityTableView = UITableView()
    let color = UIColor(red: 27/255, green: 67/255, blue: 72/255, alpha: 1)
    
    mutating func setupUI(for viewController: ViewController) {
        
        generalStackView.axis = .vertical
        generalStackView.alignment = .trailing
        generalStackView.distribution = .fill
        generalStackView.spacing = 10
        
        searchStackView.axis = .horizontal
        searchStackView.alignment = .trailing
        searchStackView.spacing = 10
        
        currentLocationButton.setImage(UIImage(systemName: "location"), for: .normal)
        currentLocationButton.tintColor = color
        
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addButton.tintColor = color
        cityTableView.layer.cornerRadius = 20
        
        imageView.image = UIImage(named: "image")
        imageView.tintColor = color
        imageView.contentMode = .scaleAspectFit
        
        tempStackView.axis = .horizontal
        tempStackView.spacing = 10
        tempStackView.contentMode = .bottom
        
        degreeLabel.font = UIFont.boldSystemFont(ofSize: 80)
        degreeLabel.textColor = color
        degreeLabel.contentMode = .bottom
        
        iconDegreeLabel.font = UIFont.systemFont(ofSize: 100, weight: .thin)
        iconDegreeLabel.text = "°"
        iconDegreeLabel.textColor = color
        iconDegreeLabel.contentMode = .bottom
        
        celsiusLabel.font = UIFont.systemFont(ofSize: 100, weight: .light)
        celsiusLabel.text = "C"
        celsiusLabel.textColor = color
        celsiusLabel.contentMode = .bottom
        
        cityNameLabel.textColor = color
        cityNameLabel.font = UIFont.systemFont(ofSize: 30, weight: .light)
        
        collectionView.backgroundColor = .clear
        
        generalStackView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        tempStackView.translatesAutoresizingMaskIntoConstraints = false
        cityNameLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        cityTableView.translatesAutoresizingMaskIntoConstraints = false
        
        viewController.view.addSubview(collectionView)
        viewController.view.addSubview(cityTableView)
        viewController.view.addSubview(generalStackView)
        generalStackView.addArrangedSubview(searchStackView)
        generalStackView.addArrangedSubview(imageView)
        generalStackView.addArrangedSubview(tempStackView)
        generalStackView.addArrangedSubview(cityNameLabel)
        searchStackView.addArrangedSubview(currentLocationButton)
        searchStackView.addArrangedSubview(searchBar)
        searchStackView.addArrangedSubview(addButton)
        tempStackView.addArrangedSubview(degreeLabel)
        tempStackView.addArrangedSubview(iconDegreeLabel)
        tempStackView.addArrangedSubview(celsiusLabel)

        
        NSLayoutConstraint.activate([
            searchStackView.heightAnchor.constraint(equalToConstant: 40),
            searchStackView.centerXAnchor.constraint(equalTo: generalStackView.centerXAnchor),
            
            currentLocationButton.heightAnchor.constraint(equalToConstant: 40),
            currentLocationButton.centerYAnchor.constraint(equalTo: searchStackView.centerYAnchor),
            currentLocationButton.topAnchor.constraint(equalTo: searchStackView.topAnchor, constant: 0),
            currentLocationButton.leadingAnchor.constraint(equalTo: searchStackView.leadingAnchor, constant: 0),
            
            searchBar.heightAnchor.constraint(equalToConstant: 40),
            searchBar.centerYAnchor.constraint(equalTo: searchStackView.centerYAnchor),
            searchBar.topAnchor.constraint(equalTo: searchStackView.topAnchor, constant: 0),
            searchBar.leadingAnchor.constraint(equalTo: currentLocationButton.trailingAnchor, constant: 0),
            searchBar.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: 0),
            
            addButton.heightAnchor.constraint(equalToConstant: 40),
            addButton.centerYAnchor.constraint(equalTo: searchStackView.centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: searchStackView.trailingAnchor, constant: 0),
            addButton.topAnchor.constraint(equalTo: searchStackView.topAnchor, constant: 0),
            
            cityTableView.topAnchor.constraint(equalTo: searchStackView.bottomAnchor, constant: 2),
            cityTableView.leadingAnchor.constraint(equalTo: generalStackView.leadingAnchor, constant: 0),
            cityTableView.trailingAnchor.constraint(equalTo: generalStackView.trailingAnchor, constant: 0),
            
            imageView.heightAnchor.constraint(equalToConstant: 100),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.trailingAnchor.constraint(equalTo: generalStackView.trailingAnchor, constant: 0),
            imageView.topAnchor.constraint(equalTo: searchStackView.bottomAnchor, constant: 10),
            
            tempStackView.trailingAnchor.constraint(equalTo: generalStackView.trailingAnchor, constant: 0),
            tempStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            tempStackView.heightAnchor.constraint(equalToConstant: 120),
            
            degreeLabel.leadingAnchor.constraint(equalTo: tempStackView.leadingAnchor, constant: 0),
            degreeLabel.topAnchor.constraint(equalTo: tempStackView.topAnchor, constant: 0),
            
            iconDegreeLabel.leadingAnchor.constraint(equalTo: degreeLabel.trailingAnchor, constant: 0),
            iconDegreeLabel.trailingAnchor.constraint(equalTo: celsiusLabel.leadingAnchor, constant: 0),
            iconDegreeLabel.topAnchor.constraint(equalTo: tempStackView.topAnchor, constant: 0),
            
            celsiusLabel.trailingAnchor.constraint(equalTo: tempStackView.trailingAnchor, constant: 0),
            celsiusLabel.topAnchor.constraint(equalTo: tempStackView.topAnchor, constant: 0),
            
            cityNameLabel.trailingAnchor.constraint(equalTo: generalStackView.trailingAnchor, constant: 0),
            cityNameLabel.topAnchor.constraint(equalTo: tempStackView.bottomAnchor, constant: 10),
        ])
        
        portraitConstraints = [
            generalStackView.topAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            generalStackView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor, constant: 20),
            generalStackView.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor, constant: -20),
            generalStackView.heightAnchor.constraint(equalToConstant: 340),
            
            collectionView.topAnchor.constraint(equalTo: generalStackView.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor, constant: 0),
            
            cityTableView.bottomAnchor.constraint(equalTo: generalStackView.bottomAnchor, constant: 105)
        ]

        landscapeLeftConstraints = [
            generalStackView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor, constant: 20),
            generalStackView.topAnchor.constraint(equalTo: viewController.view.topAnchor, constant: 20),
            generalStackView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor),
            generalStackView.trailingAnchor.constraint(equalTo: collectionView.leadingAnchor, constant: -8),
                
            collectionView.topAnchor.constraint(equalTo: viewController.view.topAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: viewController.view.centerXAnchor, constant: -5),
            collectionView.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor),
            
            cityTableView.bottomAnchor.constraint(equalTo: generalStackView.bottomAnchor, constant: -10)
        ]

        landscapeRightConstraints = [
            generalStackView.leadingAnchor.constraint(equalTo: viewController.view.centerXAnchor, constant: -5),
            generalStackView.topAnchor.constraint(equalTo: viewController.view.topAnchor, constant: 20),
            generalStackView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor),
            generalStackView.trailingAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
                
            collectionView.topAnchor.constraint(equalTo: viewController.view.topAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: generalStackView.leadingAnchor, constant: -5),
            collectionView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor, constant: 20),
            
            cityTableView.bottomAnchor.constraint(equalTo: generalStackView.bottomAnchor, constant: -10)
        ]


        portraitUpsideDownConstraints = [
            generalStackView.topAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            generalStackView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor, constant: 20),
            generalStackView.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor, constant: -20),
            generalStackView.heightAnchor.constraint(equalToConstant: 340),
            collectionView.topAnchor.constraint(equalTo: generalStackView.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor, constant: 0),
            
            cityTableView.bottomAnchor.constraint(equalTo: generalStackView.bottomAnchor, constant: 105)
        ]
    }
}
