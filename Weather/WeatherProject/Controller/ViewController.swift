//
//  ViewController.swift
//  Weather
//
//  Created by Konstantin Lyashenko on 14.02.2023.
//

import UIKit
import CoreLocation

final class ViewController: UIViewController {
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var cityTableView: UITableView!
    
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    var id: Int?
    let refreshControl = UIRefreshControl()
    var results: [City] = []
    
    private var data: [DataModel] = DataModel.loadData() {
        didSet {
            DataModel.save(data)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        cityTableView.delegate = self
        cityTableView.dataSource = self
        cityTableView.isHidden = true
        cityTableView.separatorStyle = .none
        cityTableView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        
        let collectionNib = UINib(nibName: "WeatherCollectionViewCell", bundle: nil)
        myCollectionView.register(collectionNib, forCellWithReuseIdentifier: "Cell")
        let tableNib = UINib(nibName: "CityTableViewCell", bundle: nil)
        cityTableView.register(tableNib, forCellReuseIdentifier: "CityCell")
        
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        myCollectionView.addSubview(refreshControl)
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        
        myCollectionView.dragInteractionEnabled = true
        myCollectionView.dropDelegate = self
        
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        
        weatherManager.delegate = self
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture))
        myCollectionView.addGestureRecognizer(longPressGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocation()
    }
    
    @IBAction func currentLocationButton(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    @IBAction func addDataButton(_ sender: UIButton) {
        guard let id = id else { return }
        let addData = DataModel(name: cityNameLabel.text ?? "", id: id)
        self.data.append(addData)
        myCollectionView.reloadData()
    }
    
    // Function for handling pull-to-refresh event
    @objc private func refreshTable() {
        myCollectionView.reloadData()
        refreshControl.endRefreshing()
    }
    
    // Function for update cell position
    @objc private func handleLongPressGesture(_ gestureRecognizer: UILongPressGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            guard let selectedIndexPath = myCollectionView.indexPathForItem(at: gestureRecognizer.location(in: myCollectionView)) else { return }
            myCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            myCollectionView.updateInteractiveMovementTargetPosition(gestureRecognizer.location(in: myCollectionView))
        case .ended:
            myCollectionView.endInteractiveMovement()
            DataModel.save(data)
        default:
            myCollectionView.cancelInteractiveMovement()
        }
    }
}

// MARK: - UICollectionViewDelegate, WeatherCollectionViewCellDelegate
extension ViewController: UICollectionViewDelegate, WeatherCollectionViewCellDelegate {
    func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func deleteCell(_ cell: WeatherCollectionViewCell) {
        guard let indexPath = myCollectionView.indexPath(for: cell) else { return }
        self.data.remove(at: indexPath.row)
        DataModel.save(self.data)
        self.myCollectionView.reloadData()
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
        temperatureLabel.text = weather.temperatureString
        weatherImageView.image = UIImage(systemName: weather.conditionName)
        cityNameLabel.text = weather.cityName
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

// MARK: - UITextViewDelegate, UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = results[indexPath.row]
        searchBar.text = "\(selectedCity.name), \(selectedCity.country)"
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
        let city = results[indexPath.row]
        cell.cityCellLabel?.text = "\(city.name), \(city.country)"
        return cell
    }
}
