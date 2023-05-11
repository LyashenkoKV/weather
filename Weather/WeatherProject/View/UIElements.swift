//
//  UIElements.swift
//  WeatherProject
//
//  Created by Konstantin Lyashenko on 25.04.2023.
//

import UIKit

final class MyView: UIView {
    private var portraitConstraints: [NSLayoutConstraint] = []
    private var portraitUpsideDownConstraints: [NSLayoutConstraint] = []
    private var landscapeLeftConstraints: [NSLayoutConstraint] = []
    private var landscapeRightConstraints: [NSLayoutConstraint] = []
    
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
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let cityTableView = UITableView()
    
    func setupUI(for viewController: UIViewController) {
        addSubviews(to: viewController.view)
        addConstraints(to: viewController.view)
        addTableViewConstraints(to: viewController.view)
        configureStackViews()
        configureButtons()
        configureLabels()
        configureImageView()
        configureSearchBar()
        configureCollectionView()
        configureTableView()
        NSLayoutConstraint.activate(portraitConstraints)
    }
    
    func updateConstraintsForOrientation() {
        switch UIDevice.current.orientation {
        case .portrait:
            NSLayoutConstraint.activate(portraitConstraints)
            NSLayoutConstraint.deactivate([landscapeLeftConstraints, landscapeRightConstraints, portraitUpsideDownConstraints].flatMap { $0 })
        case .portraitUpsideDown:
            NSLayoutConstraint.activate(portraitUpsideDownConstraints)
            NSLayoutConstraint.deactivate([portraitConstraints, landscapeLeftConstraints, landscapeRightConstraints].flatMap { $0 })
        case .landscapeLeft:
            NSLayoutConstraint.activate(landscapeLeftConstraints)
            NSLayoutConstraint.deactivate([portraitConstraints, portraitUpsideDownConstraints, landscapeRightConstraints].flatMap { $0 })
        case .landscapeRight:
            NSLayoutConstraint.activate(landscapeRightConstraints)
            NSLayoutConstraint.deactivate([portraitConstraints, portraitUpsideDownConstraints, landscapeLeftConstraints].flatMap { $0 })
        default:
            break
        }
    }
    
    private func configureStackViews() {
        generalStackView.axis = .vertical
        generalStackView.alignment = .trailing
        generalStackView.distribution = .fill
        generalStackView.spacing = 10
        
        searchStackView.axis = .horizontal
        searchStackView.alignment = .trailing
        searchStackView.spacing = 10
        
        tempStackView.axis = .horizontal
        tempStackView.spacing = 10
        tempStackView.contentMode = .bottom
    }
    
    private func configureButtons() {
        currentLocationButton.setImage(UIImage(systemName: "location"), for: .normal)
        currentLocationButton.tintColor = myTintColor
        
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addButton.tintColor = myTintColor
    }
    
    private func configureLabels() {
        degreeLabel.font = UIFont.boldSystemFont(ofSize: 80)
        degreeLabel.textColor = myTintColor
        
        iconDegreeLabel.font = UIFont.systemFont(ofSize: 100, weight: .thin)
        iconDegreeLabel.text = "°"
        iconDegreeLabel.textColor = myTintColor
        
        celsiusLabel.font = UIFont.systemFont(ofSize: 100, weight: .light)
        celsiusLabel.text = "C"
        celsiusLabel.textColor = myTintColor
        
        cityNameLabel.textColor = myTintColor
        cityNameLabel.font = UIFont.systemFont(ofSize: 30, weight: .light)
    }
    
    private func configureImageView() {
        imageView.image = UIImage(named: "image")
        imageView.tintColor = myTintColor
        imageView.contentMode = .scaleAspectFit
    }
    
    private func configureSearchBar() {
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .clear
    }
    
    private func configureTableView() {
        cityTableView.layer.cornerRadius = 20
        cityTableView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
    }
    
    private func addSubviews(to view: UIView) {
        generalStackView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        tempStackView.translatesAutoresizingMaskIntoConstraints = false
        cityNameLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        cityTableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(generalStackView)
        view.addSubview(collectionView)
        view.addSubview(cityTableView)
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
    }

    private func addTableViewConstraints(to view: UIView) {
        NSLayoutConstraint.activate([
            cityTableView.topAnchor.constraint(equalTo: searchStackView.bottomAnchor, constant: 2),
            cityTableView.leadingAnchor.constraint(equalTo: generalStackView.leadingAnchor, constant: 0),
            cityTableView.trailingAnchor.constraint(equalTo: generalStackView.trailingAnchor, constant: 0),
        ])
    }
   
    private func addConstraints(to view: UIView) {
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
            generalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            generalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            generalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            generalStackView.heightAnchor.constraint(equalToConstant: 340),
            
            collectionView.topAnchor.constraint(equalTo: generalStackView.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ]
        
        landscapeLeftConstraints = [
            generalStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            generalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            generalStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            generalStackView.trailingAnchor.constraint(equalTo: collectionView.safeAreaLayoutGuide.leadingAnchor, constant: -5),
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: -5),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ]

        landscapeRightConstraints = [
            generalStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: -5),
            generalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            generalStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            generalStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: generalStackView.safeAreaLayoutGuide.leadingAnchor, constant: -5),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
        ]
        
        portraitUpsideDownConstraints = [
            generalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            generalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            generalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            generalStackView.heightAnchor.constraint(equalToConstant: 340),
            
            collectionView.topAnchor.constraint(equalTo: generalStackView.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ]
    }
    
    func updateTableViewBottomAnchor(parameter: Notification, to view: UIView) {
        let userInfo = parameter.userInfo
        let getKeyboardRect = (userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardFrame = view.convert(getKeyboardRect, to: view.window)

        if parameter.name == UIResponder.keyboardWillHideNotification {
            cityTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        } else {
            cityTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardFrame.height - 5).isActive = true
        }
        view.layoutIfNeeded()
    }
}
