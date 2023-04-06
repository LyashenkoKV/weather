//
//  ViewController.swift
//  Weather
//
//  Created by Konstantin Lyashenko on 14.02.2023.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var myTableView: UITableView!
    
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
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
        let nib = UINib(nibName: "WeatherTableViewCell", bundle: nil)
        myTableView.register(nib, forCellReuseIdentifier: "xibCellId")
        
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        myTableView.addSubview(refreshControl)
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        
        searchTextField.delegate = self
        weatherManager.delegate = self
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
        myTableView.reloadData()
    }
    
    // Function for handling pull-to-refresh event
    @objc private func refreshTable() {
        myTableView.reloadData()
        refreshControl.endRefreshing()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "xibCellId", for: indexPath) as! WeatherTableViewCell
        //cell.isUserInteractionEnabled = false
        cell.configure(data[indexPath.row])
        return cell
    }
    
    // delete rows
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            data.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
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
            weatherManager.fetchWeather(cityName: city)
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
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
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
