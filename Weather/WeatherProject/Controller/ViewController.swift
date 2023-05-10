//
//  ViewController.swift
//  Weather
//
//  Created by Konstantin Lyashenko on 14.02.2023.
//

import UIKit
import CoreLocation

final class ViewController: UIViewController {
    
    private var myView = MyView()
    private var weatherManager = WeatherManager()
    
    private var locationManager = CLLocationManager()
    private var id: Int?
    private let refreshControl = UIRefreshControl()
    private var results: [CityModel] = []
    private var selectedIndexPath: IndexPath?

    private var data: [DataModel] = DataModel.loadData() {
        didSet {
            DataModel.save(data)
        }
    }
    
    private lazy var searchBar: UISearchBar = {
        return myView.searchBar
    }()
    
    private lazy var collectionView: UICollectionView = {
        return myView.collectionView
    }()
    
    private lazy var cityTableView: UITableView = {
        return myView.cityTableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocation()

        myView.setupUI(for: self)
        
        tableViewSettings()
        collectionViewSettings()
        
        refreshControl.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
        view.addGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        
        myView.currentLocationButton.addTarget(self, action: #selector(currentLocationButton), for: .touchUpInside)
        myView.addButton.addTarget(self, action: #selector(addDataButton), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableViewBottomAnchor(parameter:)),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableViewBottomAnchor(parameter:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        
        searchBar.delegate = self
        weatherManager.delegate = self
    }
    
    override func viewWillLayoutSubviews() {
        super.viewDidLayoutSubviews()
        myView.updateConstraintsForOrientation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.view.layer.sublayers?.first(where: { $0.name == "GradientLayer" })?.frame = self.view.bounds
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate { [weak self] _ in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.collectionView.collectionViewLayout.invalidateLayout()
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func currentLocationButton() {
        locationManager.requestLocation()
    }
    
    @objc func addDataButton() {
        guard let id = id else { return }
        let addData = DataModel(name: myView.cityNameLabel.text ?? "", id: id)
        self.data.append(addData)
        collectionView.reloadData()
    }
    
    // MARK: - tableViewSettings
    fileprivate func tableViewSettings() {
        cityTableView.register(CityTableViewCell.self, forCellReuseIdentifier: "CityCell")
        cityTableView.delegate = self
        cityTableView.dataSource = self
        cityTableView.isHidden = true
        cityTableView.separatorStyle = .none
    }
    
    @objc func updateTableViewBottomAnchor(parameter: Notification) {
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
    
    // MARK: - collectionViewSettings
    fileprivate func collectionViewSettings() {
        collectionView.register(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.addSubview(refreshControl)
        collectionView.dragInteractionEnabled = true
        collectionView.dropDelegate = self
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture))
        collectionView.addGestureRecognizer(longPressGesture)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        let point = touch.location(in: view)
        
        if !cityTableView.isHidden {
            cityTableView.isHidden = true
        }
        
        if let selectedIndexPath = self.selectedIndexPath,
           let cell = collectionView.cellForItem(at: selectedIndexPath) as? WeatherCollectionViewCell,
           !cell.frame.contains(point) {
            cell.deleteCellButton.isHidden = true
            self.selectedIndexPath = nil
        }
    }
    
    // Function for handling pull-to-refresh event
    @objc private func refreshCollectionView() {
        collectionView.reloadData()
        refreshControl.endRefreshing()
    }
    
    // Function for update cell position
    @objc private func handleLongPressGesture(_ gestureRecognizer: UILongPressGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gestureRecognizer.location(in: collectionView)) else { return }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gestureRecognizer.location(in: collectionView))
        case .ended:
            collectionView.endInteractiveMovement()
            DataModel.save(data)
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
}

// MARK: - UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? WeatherCollectionViewCell {
            cell.deleteCellButton.isHidden = false
            
            if !cityTableView.isHidden {
                cityTableView.isHidden = true
            }

            if let selectedIndexPath = self.selectedIndexPath,
                selectedIndexPath != indexPath,
                let selectedCell = collectionView.cellForItem(at: selectedIndexPath) as? WeatherCollectionViewCell {
                selectedCell.deleteCellButton.isHidden = true
            }
            self.selectedIndexPath = indexPath
        }
    }
}

// MARK: - WeatherCollectionViewCellDelegate
extension ViewController: WeatherCollectionViewCellDelegate {
    func deleteCell(_ cell: CollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        self.data.remove(at: indexPath.row)
        DataModel.save(self.data)
        self.collectionView.reloadData()
        cell.deleteCellButton.isHidden = true
    }
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! WeatherCollectionViewCell
        cell.configure(data[indexPath.row])
        cell.delegate = self
        cell.layer.cornerRadius = 20
        cell.layer.borderWidth = 1
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.bounds.width - 10
        let cellHeight = CGFloat(80)
        
        let maxWidth = collectionView.bounds.width
        let maxHeight = collectionView.bounds.height
        
        return CGSize(width: min(cellWidth, maxWidth), height: min(cellHeight, maxHeight))
    }
}

// MARK: - UICollectionViewDropDelegate
extension ViewController: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = data.remove(at: sourceIndexPath.item)
           data.insert(item, at: destinationIndexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
    }
}

// MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let city = searchBar.text {
            weatherManager.fetchWeather(with: .byCityName(city))
        }
        searchBar.text = ""
        cityTableView.isHidden = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            results = []
            cityTableView.reloadData()
            cityTableView.isHidden = true
        } else {
            NetworkManager.shared.fetchCities(for: searchText) { [weak self] result in
                switch result {
                case .success(let cities):
                    DispatchQueue.main.async {
                        self?.results = cities
                        self?.cityTableView.reloadData()
                        self?.cityTableView.isHidden = cities.isEmpty
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
}

// MARK: - WeatherManagerDelegate
extension ViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        id = weather.id
        myView.degreeLabel.text = weather.temperatureString
        myView.imageView.image = UIImage(systemName: weather.conditionName)
        myView.cityNameLabel.text = weather.cityName
    }
    
    func didFailWithError(error: Error) {
        print(error.localizedDescription)
    }
}

// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(with: .byCoordinates(lat, lon))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    func setupLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.requestLocation()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = results[indexPath.row]
        myView.searchBar.text = "\(selectedCity.name), \(selectedCity.country)"
        tableView.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as! CityTableViewCell
        cell.backgroundColor = .clear
        let city = results[indexPath.row]
        cell.cityCellLabel?.text = "\(city.name), \(city.country)"
        return cell
    }
}
