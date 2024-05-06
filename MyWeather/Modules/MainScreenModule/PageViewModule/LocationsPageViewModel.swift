//
//  LocationsPageViewModel.swift
//  Weather
//
//  Created by Миша Вашкевич on 15.04.2024.
//

import Foundation
import UIKit
import CoreLocation
import CoreData

protocol LocationsPageViewModelProtocol {
    
    var dataFetchState: ((DataLoadingState) -> Void)? {get set}
    var views: [UIViewController] {get}
    var numberOfPages: Int {get}
    
    func fetchViews()
    func locationsListButtonTapped()
    func requestUseGeolocation(alertPresenter: UIViewController)
    func goToRoot()
}

final class LocationsPageViewModel: NSObject, LocationsPageViewModelProtocol {
    
    // MARK: Properties
    
    private var coreDataManager: CoreDataManagerProtocol
    private var networkManager: WeatherNetworkManagerProtocol
    private var userSettings: UserAppSettings
    private let locationManager = CLLocationManager()
    var coordinator: MainScreenCoordinator?
    var currentAuthorizationStatus: CLAuthorizationStatus? = nil
    
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
    
    init(coreDataManager: CoreDataManagerProtocol, networkManager: WeatherNetworkManagerProtocol, userSettings: UserAppSettings) {
        self.coreDataManager = coreDataManager
        self.networkManager = networkManager
        self.userSettings = userSettings
    }
    
    deinit {
        print("LocationsPageViewModel deinit")
    }
    
    // MARK: Private Methods

    private func configCurrentLocationView() {
        
        switch locationManager.authorizationStatus {
        case .restricted, .denied, .notDetermined:
            let view = LocationAccessView(viewModel: self)
            views.insert(view, at: 0)
            dispatchGroup.leave()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        default:
            print("look hire")
        }
    }
    
    // MARK: Public Methods
    let dispatchGroup = DispatchGroup()
    func fetchViews() {
        
        dispatchGroup.enter()
        
        views = []
        locationManager.delegate = self
        self.state = .loading
        
        configCurrentLocationView()
        
        dispatchGroup.enter()
            self.coreDataManager.fetchPlaces { result in
                switch result {
                case .success(let fetchedPlaces):
                    if !fetchedPlaces.isEmpty {
                        for place in fetchedPlaces {
                            let viewModel = LocationWeatherViewModel(weatherNetworkManager: self.networkManager,
                                                                     coreDataManager: self.coreDataManager,
                                                                     currentPlace: place,
                                                                     userSettings: self.userSettings)
                            let viewController = LocationWeatherViewController(viewModel: viewModel)
                            self.views.append(viewController)
                        }
                    }
                case .failure(let error):
                    self.state = .error(error)
                    dispatchGroup.leave()
                }
                dispatchGroup.leave()
            }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else {return}
            self.state = .success
            print(views)
        }
    }
    
    func goToRoot() {
        fetchViews()
        coordinator?.navigationController.popToRootViewController(animated: true)
    }
    
    // MARK: Public Methods
    
    func locationsListButtonTapped() {
        coordinator?.showAddLocationView(userSettings: userSettings)
    }
    
    func requestUseGeolocation(alertPresenter: UIViewController) {    
        
        self.currentAuthorizationStatus = locationManager.authorizationStatus
        
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
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        getPlacemark(location: location) { [weak self] placemark in
            
            guard let self = self else {return }
            let newPlace = PlaceModel(name: "\(placemark.locality!.capitalized)", latitude: "\(latitude)", longitude: "\(longitude)", updateDate: Date())
            let viewModel = LocationWeatherViewModel(weatherNetworkManager: self.networkManager,
                                                     coreDataManager: self.coreDataManager,
                                                     newplace: newPlace,
                                                     userSettings: self.userSettings,
                                                     viewState: .currentLocation)
            let viewController = LocationWeatherViewController(viewModel: viewModel)
            self.views.insert(viewController, at: 0)
            dispatchGroup.leave()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            // Обработка ошибки запроса местоположения
            locationManager.requestLocation()
        }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if currentAuthorizationStatus != nil {
            switch status {
            case .authorizedWhenInUse, .authorizedAlways, .notDetermined:
                fetchViews()
            default:
                print("Непредвиденное значение статуса авторизации")
            }
        }
    }
}

protocol LocationsPageViewModelDelegate: AnyObject {
    func locationDelete()
}

extension LocationsPageViewModel: LocationsPageViewModelDelegate {
    func locationDelete() {
        fetchViews()
    }
}


