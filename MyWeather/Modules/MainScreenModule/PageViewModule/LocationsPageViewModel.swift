//
//  LocationsPageViewModel.swift
//  Weather
//
//  Created by Миша Вашкевич on 15.04.2024.
//

import Foundation
import UIKit
import CoreLocation

protocol LocationsPageViewModelProtocol {
    
    var dataFetchState: ((DataLoadingState) -> Void)? {get set}
    var views: [UIViewController] {get}
    var numberOfPages: Int {get}
    
    func fetchViews()
    func locationsListButtonTapped()
    func requestUseGeolocation(alertPresenter: UIViewController)
}

final class LocationsPageViewModel: NSObject, LocationsPageViewModelProtocol {
    
    // MARK: Properties
    
    private var coreDataManager: CoreDataManagerProtocol
    private var networkManager: WeatherNetworkManagerProtocol
    private var userSettings: UserAppSettings?
    private let locationManager = CLLocationManager()
    private let userSettingsDataManager: UserSettingsDataManager
    private var locationUpdateCompletion: (() -> Void)?
    var coordinator: MainScreenCoordinator?
    
    var dataFetchState: ((DataLoadingState) -> Void)?
    private var state: DataLoadingState = .initial {
        didSet {
            dataFetchState?(state)
        }
    }
    var views: [UIViewController] = []
    var numberOfPages: Int {
        views.count
    }
    
    // MARK: lifeCycle
    
    init(coreDataManager: CoreDataManagerProtocol, networkManager: WeatherNetworkManagerProtocol, userSettingsDataManager: UserSettingsDataManager) {
        self.coreDataManager = coreDataManager
        self.networkManager = networkManager
        self.userSettingsDataManager = userSettingsDataManager
    }
    
    deinit {
        print("LocationsPageViewModel deinit")
    }
    
    // MARK: Private Methods

    private func configCurrentLocationView() {
        
        switch locationManager.authorizationStatus {
        case .restricted, .denied, .notDetermined:
            let view = LocationAccessView(viewModel: self)
            views.append(view)
            locationUpdateCompletion?()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            print("look hire")
        }
    }
    
    // MARK: Public Methods
    
    private func fetchLocations() {
        self.state = .loading
        
        configCurrentLocationView()
        
        locationUpdateCompletion = {
            self.coreDataManager.fetchPlaces { result in
                switch result {
                case .success(let fetchedPlaces):
                    if !fetchedPlaces.isEmpty {
                        for place in fetchedPlaces {
                            let viewModel = LocationWeatherViewModel(weatherNetworkManager: self.networkManager,
                                                                     coreDataManager: self.coreDataManager,
                                                                     currentPlace: place,
                                                                     userSettings: self.userSettings!)
                            let viewController = LocationWeatherView(viewModel: viewModel)
                            self.views.append(viewController)
                        }
                    }
                    self.state = .success
                case .failure(let error):
                    self.state = .error(error)
                }
            }
        }
    }
    
    // MARK: Public Methods
    
    func fetchViews() {
        views = []
        locationManager.delegate = self
        userSettingsDataManager.loadSettings { [weak self] result in
            switch result {
            case .success(let settings):
                self?.userSettings = settings
                self?.fetchLocations()
            case .failure(let error):
                self?.state = .error(error)
            }
        }
    }
    
    func locationsListButtonTapped() {
        coordinator?.showAddLocationView(userSettings: userSettings!)
    }
    
    func requestUseGeolocation(alertPresenter: UIViewController) {
        
        switch locationManager.authorizationStatus {
        case .denied, .restricted:
            showAlert(title: "Геолокация отключена", message: "Вы можете изменить доступ в настройках приложения", target: alertPresenter, handler: nil)
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
}

extension LocationsPageViewModel: CLLocationManagerDelegate {
    
    private func getPlacemark(location: CLLocation, completion: @escaping (CLPlacemark) -> ()) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            
            if let error = error {
                print(error.localizedDescription)
            } else {
                
                if let placemark = placemarks?.first {
                        completion(placemark)
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return }
        self.locationManager.stopUpdatingLocation()
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        getPlacemark(location: location) { [weak self] placemark in
            
            guard let self = self else {return }
            let newPlace = PlaceModel(name: "\(placemark.locality!.capitalized)", latitude: "\(latitude)", longitude: "\(longitude)", updateDate: Date())
            let viewModel = LocationWeatherViewModel(weatherNetworkManager: self.networkManager,
                                                     coreDataManager: self.coreDataManager,
                                                     newplace: newPlace,
                                                     userSettings: self.userSettings!,
                                                     viewState: .currentLocation)
            let viewController = LocationWeatherView(viewModel: viewModel)
            self.views.append(viewController)
            self.locationUpdateCompletion?()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
           switch status {
           case .authorizedWhenInUse, .authorizedAlways:
               fetchViews()
           default:
               print("Непредвиденное значение статуса авторизации")
           }
    }
}


