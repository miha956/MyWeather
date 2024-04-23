//
//  SearchLocationViewModel.swift
//  Weather
//
//  Created by Миша Вашкевич on 13.04.2024.
//

import Foundation
import UIKit

protocol SearchLocationViewModelProtocol {
    var numberOfRows: Int {get}
    func searchLocation(name: String, complitoin: @escaping() -> Void)
    func confinCell(for indexPath: IndexPath) -> (title: String? ,description: String?)
    func removeSearchResult()
    func locationSelected(indexPath: IndexPath, presenter: UIViewController)
    func goToRoot()
}

final class SearchLocationViewModel: SearchLocationViewModelProtocol {
    
    // MARK: Properties
    
    private let weatherNetworkManager: WeatherNetworkManagerProtocol
    private let coreDataManager: CoreDataManagerProtocol
    private var userSettings: UserAppSettings
    var coordinator: MainScreenCoordinator?
    
    var searchResults: GeocodingModel?
    var numberOfRows: Int {
        searchResults?.response.geoObjectCollection.featureMember.count ?? 0
    }
    
    // MARK: lifeCycle
    
    init(weatherNetworkManager: WeatherNetworkManagerProtocol, coreDataManager: CoreDataManagerProtocol, userSettings: UserAppSettings) {
        self.weatherNetworkManager = weatherNetworkManager
        self.coreDataManager = coreDataManager
        self.userSettings = userSettings
    }
    
    deinit {
        print("SearchLocationViewModel deinit")
    }
    
    func searchLocation(name: String, complitoin: @escaping() -> Void) {
        weatherNetworkManager.fetchLocationGeocoding(name: name) { result in
            switch result {
            case .success(let locations):
                self.searchResults = locations
                complitoin()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func confinCell(for indexPath: IndexPath) -> (title: String? ,description: String?) {
        print(indexPath.row)
        let title = searchResults?.response.geoObjectCollection.featureMember[indexPath.row].geoObject.name
        let description = searchResults?.response.geoObjectCollection.featureMember[indexPath.row].geoObject.description
        return (title: title, description: description)
    }
    
    func removeSearchResult() {
        self.searchResults = nil
    }
    func locationSelected(indexPath: IndexPath, presenter: UIViewController) {
        let name = searchResults!.response.geoObjectCollection.featureMember[indexPath.row].geoObject.name
        let coordinates = searchResults!.response.geoObjectCollection.featureMember[indexPath.row].geoObject.point.pos.components(separatedBy: " ")
        let plece = PlaceModel(name: name,
                               latitude: coordinates[1],
                               longitude: coordinates[0],
                               updateDate: Date())
        let viewModel = LocationWeatherViewModel(weatherNetworkManager: weatherNetworkManager,
                                                 coreDataManager: coreDataManager,
                                                 newplace: plece,
                                                 userSettings: userSettings, 
                                                 viewState: .addLocation)
        let viewController = LocationWeatherView(viewModel: viewModel)
        viewController.view.backgroundColor = .appWhite
        DispatchQueue.main.async {
            presenter.present(viewController, animated: true)
        }
    }
    
    func goToRoot() {
        coordinator?.navigationController.popToRootViewController(animated: true)
    }
    
}
