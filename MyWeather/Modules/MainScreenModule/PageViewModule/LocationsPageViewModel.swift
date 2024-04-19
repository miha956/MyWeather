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
}

final class LocationsPageViewModel: LocationsPageViewModelProtocol {
    
    // MARK: Properties
    
    private var coreDataManager: CoreDataManagerProtocol
    private var networkManager: WeatherNetworkManagerProtocol
    private let locationManager = CLLocationManager()
    private let userSettingsDataManager: UserSettingsDataManager
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
    
    private func checkAuthorizationStatus(userSettings: UserAppSettings) {
        
        switch locationManager.authorizationStatus {
        case .restricted, .denied, .notDetermined:
            let viewModel = LocationWeatherViewModel(weatherNetworkManager: networkManager,
                                                     coreDataManager: coreDataManager, 
                                                     userSettings: userSettings)
            let viewController = LocationWeatherView(viewModel: viewModel)
            views.append(viewController)
        default:
            let viewModel = LocationWeatherViewModel(weatherNetworkManager: networkManager,
                                                     coreDataManager: coreDataManager,
                                                     userSettings: userSettings)
            viewModel.viewState = .authorized
            let viewController = LocationWeatherView(viewModel: viewModel)
            views.append(viewController)
        }
        
    }
    

    // MARK: Public Methods
    
    private func fetchLocations(userSettings: UserAppSettings) {
        
        state = .loading
        
        coreDataManager.fetchPlaces { result in
            switch result {
            case .success(let fetchedPlaces):
                if fetchedPlaces.isEmpty {
                    checkAuthorizationStatus(userSettings: userSettings)
                } else {
                    for place in fetchedPlaces {
                        let viewModel = LocationWeatherViewModel(weatherNetworkManager: networkManager,
                                                                 coreDataManager: coreDataManager,
                                                                 currentPlace: place, 
                                                                 userSettings: userSettings)
                        let viewController = LocationWeatherView(viewModel: viewModel)
                        views.append(viewController)
                    }
                }
                state = .success
            case .failure(let error):
                state = .error(error)
            }
        }
    }
    
    // MARK: Public Methods
    
    func fetchViews() {

        userSettingsDataManager.loadSettings { [weak self] result in
            switch result {
            case .success(let settings):
                self?.fetchLocations(userSettings: settings)
            case .failure(let error):
                self?.state = .error(error)
            }
        }
    }
    
    func locationsListButtonTapped() {
        coordinator?.showAddLocationView()
    }
}
