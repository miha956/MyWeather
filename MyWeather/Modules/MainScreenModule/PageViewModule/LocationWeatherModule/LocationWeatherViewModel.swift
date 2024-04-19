//
//  CityWeatherViewModel.swift
//  Weather
//
//  Created by Миша Вашкевич on 06.04.2024.
//

import Foundation
import UIKit
import CoreLocation

enum DataLoadingState {
    case initial
    case loading
    case success
    case error(Error?)
}

enum LocationWeatherViewState {
    case location
    case addLocation
    case requestUseAuthorization
    case authorized
}


protocol LocationWeatherViewModelProtocol {
    
    var viewState: LocationWeatherViewState { get }
    var numbersOfHoursCell: Int { get }
    var numbersOfDaysCell: Int { get }
    var dataFetchState: ((DataLoadingState) -> Void)? { get set }
    
    func saveNewLocationButtonTapped()
    func getCurrentLocation(alertPresenter: UIViewController)
    func fetchWeatherData()
    func getCurrentViewInfo() -> (locationName: String, temperature: String, weatherDescription: String, tempMax: String, tempMin: String)
    func getHourlyWeatherInfo(for indexPath: IndexPath) -> (hour: String, weatherImage: UIImage, temperature: String, precipitationProbability: String?)
    func getDailyWeatherInfo(for indexPath: IndexPath) -> (date: String, weatherImage: UIImage, precipitationProbability: String?, minTemp: String, maxTemp: String)
}


final class LocationWeatherViewModel: NSObject, LocationWeatherViewModelProtocol {
    
    // MARK: Properties
    private let locationManager = CLLocationManager()
    private let userSettings: UserAppSettings
    private let weatherNetworkManager: WeatherNetworkManagerProtocol
    private let coreDataManager: CoreDataManagerProtocol
    private var currentPlace: Place?
    private var newPlace: PlaceModel?
    private var weatherData: WeatherModel!
    private var localityTime: Int {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        dateFormatter.locale = .current
        guard let hour = Int(dateFormatter.string(from: date)) else {return 0}
        return hour
    }
    
    
    var numbersOfHoursCell: Int {
        guard weatherData != nil else {return 0}
        return 24
    }
    var numbersOfDaysCell: Int {
        guard weatherData != nil else {return 0}
        return 10
    }
    var dataFetchState: ((DataLoadingState) -> Void)?
    private var state: DataLoadingState = .initial {
        didSet {
            dataFetchState?(state)
        }
    }
    var viewState: LocationWeatherViewState = .location
    
    // MARK: lifeCycle
    
    init(weatherNetworkManager: WeatherNetworkManagerProtocol, coreDataManager: CoreDataManagerProtocol, currentPlace: Place, userSettings: UserAppSettings) {
        self.weatherNetworkManager = weatherNetworkManager
        self.coreDataManager = coreDataManager
        self.currentPlace = currentPlace
        self.userSettings = userSettings
    }
    
    init(weatherNetworkManager: WeatherNetworkManagerProtocol, coreDataManager: CoreDataManagerProtocol, newplace: PlaceModel, userSettings: UserAppSettings) {
        self.weatherNetworkManager = weatherNetworkManager
        self.coreDataManager = coreDataManager
        self.newPlace = newplace
        self.userSettings = userSettings
        viewState = .addLocation
    }
    init(weatherNetworkManager: WeatherNetworkManagerProtocol, coreDataManager: CoreDataManagerProtocol, userSettings: UserAppSettings) {
        self.weatherNetworkManager = weatherNetworkManager
        self.coreDataManager = coreDataManager
        self.userSettings = userSettings
        viewState = .requestUseAuthorization
    }
    
    deinit {
        print("LocationWeatherViewModel deinit")
    }
    
    // MARK: Public
    
    func fetchWeatherData() {
        
        state = .loading
        
        var latitude: String = ""
        var longitude: String = ""
        
        if let currentPlace = currentPlace {
            latitude = currentPlace.latitude!
            longitude = currentPlace.longitude!
        } else if let newPlace = newPlace {
            latitude = newPlace.latitude
            longitude = newPlace.longitude
        }
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        weatherNetworkManager.fetchWeatherData(latitude: latitude,
                                               longitude: longitude,
                                               temperatureUnit: userSettings.temperature.unit) { [weak self] result in
            guard let self = self else {return}
            
            switch result {
            case .success(let weatherData):
                self.weatherData = weatherData
            case .failure(let error):
                state = .error(error)
                return
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else {return}
            
            state = .success
            
            guard let locationId = self.currentPlace?.id else {return}
            self.coreDataManager.updateWeatherData(locationId: locationId, weather: weatherData)
        }
    }
    
    func getCurrentViewInfo() -> (locationName: String, temperature: String, weatherDescription: String, tempMax: String, tempMin: String) {
                
        let locationName = currentPlace?.name! ?? newPlace!.name
        let temperature = "\(weatherData.current.temperature.toInt)\(userSettings.temperature.unicode)"
        let weatherDescription = weatherData.current.weatherCode.weatherCodeDescription
        let tempMax = "\(weatherData.daily.temperatureMax.first!.toInt)\(userSettings.temperature.unicode)"
        let tempMin = "\(weatherData.daily.temperatureMin.first!.toInt)\(userSettings.temperature.unicode)"
        
        return (locationName: locationName, temperature: temperature, weatherDescription: weatherDescription, tempMax: tempMax, tempMin: tempMin)
    }
    
    func getHourlyWeatherInfo(for indexPath: IndexPath) -> (hour: String, weatherImage: UIImage, temperature: String, precipitationProbability: String?) {
    
        let index = indexPath.row + localityTime
        let hour = weatherData.hourly.time[index].getHourFromDate
        //let weatherImage = UIImage(named: "weatherCode-\(currentWeather.hourly.weatherCode[indexPath.row])")
        let weatherImage = UIImage(named: "weatherCode-0")!
        let temp = "\(weatherData.hourly.temperature[index].toInt)\(userSettings.temperature.unicode)"
        var precipitationProbability: String? {
            guard let probability = weatherData.hourly.precipitationProbability[index] else {
                return nil
            }
            return probability < 10 ? nil : "\(probability)\u{0025}"
        }
        return (hour: hour, weatherImage: weatherImage, temperature: temp, precipitationProbability: precipitationProbability)
    }
    
    func getDailyWeatherInfo(for indexPath: IndexPath) -> (date: String, weatherImage: UIImage, precipitationProbability: String?, minTemp: String, maxTemp: String) {
        
        let date = weatherData.daily.time[indexPath.row].getWeekdayFromDate
        //let weatherImage = UIImage(named: "weatherCode-\(dailyWeather.daily.weatherCode[indexPath.row])")!
        let weatherImage = UIImage(named: "weatherCode-0")!
        var precipitationProbability: String? {
            guard let probability = weatherData.daily.precipitationProbabilityMax[indexPath.row] else {
                return nil
            }
            return probability < 10 ? nil : "\(probability)\u{0025}"
        }
        let minTemp = "\(weatherData.daily.temperatureMin[indexPath.row].toInt)\(userSettings.temperature.unicode)"
        let maxTemp = "\(weatherData.daily.temperatureMax[indexPath.row].toInt)\(userSettings.temperature.unicode)"
        
        return (date: date, weatherImage: weatherImage, precipitationProbability: precipitationProbability, minTemp: minTemp, maxTemp: maxTemp)
    }
    
    func getCurrentLocation(alertPresenter: UIViewController) {
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            showAlert(title: "Geolocation denied", message: "Please change it in app settings", target: alertPresenter, handler: nil)
         default:
            print("look hire if some error")
        }
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        viewState = .location
    }
    
    func saveNewLocationButtonTapped() {
        coreDataManager.saveLocation(location: newPlace!) { _ in }
    }
}

extension LocationWeatherViewModel: CLLocationManagerDelegate {
    
    private func getPlacemark(location: CLLocation, completion: @escaping (CLPlacemark) -> ()) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            
            if let error = error {
                print(error.localizedDescription)
            } else {
                
                if let placemark = placemarks?.first {
                    DispatchQueue.main.async {
                        completion(placemark)
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        viewState = .location
        
        getPlacemark(location: location) { [weak self] placemark in
            self?.newPlace = PlaceModel(name: "\(placemark.locality!)", latitude: "\(latitude)", longitude: "\(longitude)", id: "1", updateDate: Date())
            self?.coreDataManager.saveLocation(location: (self?.newPlace!)!) { _ in }
            self?.fetchWeatherData()
        }
    }
}
