//
//  SideMenuViewModel.swift
//  MyWeather
//
//  Created by Миша Вашкевич on 02.05.2024.
//

import Foundation
import CoreData

protocol SideMenuViewModelProtocol {
    
    var numberOfPlaces: Int {get}
    func getFavoritePlaces(indexPath: IndexPath) -> (locationName: String, temp: String, weatherDescription: String, tempMin: String, tempMax: String)?
    func subscribeFetchResultController(delegate: AnyObject)
    func deletePlace(at indexPath: IndexPath)
}

final class SideMenuViewModel: SideMenuViewModelProtocol {

    private let weatherNetworkManager: WeatherNetworkManagerProtocol
    private let coreDataManager: CoreDataManagerProtocol
    private var userSettings: UserAppSettings
    var delegate: LocationsPageViewModelDelegate?
    
    var numberOfPlaces: Int {
        coreDataManager.fetchResultController.sections?[0].numberOfObjects ?? 0
    }
    
    init(weatherNetworkManager: WeatherNetworkManagerProtocol, coreDataManager: CoreDataManagerProtocol, userSettings: UserAppSettings) {
        self.weatherNetworkManager = weatherNetworkManager
        self.coreDataManager = coreDataManager
        self.userSettings = userSettings
    }
    
    func getFavoritePlaces(indexPath: IndexPath) -> (locationName: String, temp: String, weatherDescription: String, tempMin: String, tempMax: String)? {
        
        guard let place = coreDataManager.fetchResultController.fetchedObjects?[indexPath.section] else { return nil}
        guard let weatherData = place.weatherData else { return nil}
        do {
            let weather = try JSONDecoder().decode(WeatherModel.self, from: weatherData)
            return (locationName: place.name!, temp: "\(weather.current.temperature.toInt)\(userSettings.temperature.unicode)", weatherDescription: weather.current.weatherCode.weatherCodeDescription, tempMin: "\(weather.daily.temperatureMin.first!.toInt)\(userSettings.temperature.unicode)", tempMax: "\(weather.daily.temperatureMax.first!.toInt)\(userSettings.temperature.unicode)")
        } catch {
            return nil
        }
    }
    
    func subscribeFetchResultController(delegate: AnyObject) {
        coreDataManager.subscribeFetchResultController(delegate: delegate as! NSFetchedResultsControllerDelegate)
    }
    
    func deletePlace(at indexPath: IndexPath) {
        guard let place = coreDataManager.fetchResultController.fetchedObjects?[indexPath.section] else { return }
        coreDataManager.delelePlaceFromFvorite(location: place) {[weak self] result in
            switch result {
            case .success(_):
                self?.delegate?.locationDelete()
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
