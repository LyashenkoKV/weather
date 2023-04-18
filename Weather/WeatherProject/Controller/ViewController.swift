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
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var cityTableView: UITableView!
    
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    var id: Int?
    let refreshControl = UIRefreshControl()
    
    private var data: [DataModel] = DataModel.loadData() {
        didSet {
            DataModel.save(data)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        let nib = UINib(nibName: "WeatherCollectionViewCell", bundle: nil)
        myCollectionView.register(nib, forCellWithReuseIdentifier: "Cell")
        
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        myCollectionView.addSubview(refreshControl)
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        
        myCollectionView.dragInteractionEnabled = true
        myCollectionView.dropDelegate = self
        
        searchTextField.delegate = self
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
    
    @IBAction func searchButton(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
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


// MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        searchTextField.text = ""
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchWeather(with: .byCityName(city))
        }
        searchTextField.text = ""
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
