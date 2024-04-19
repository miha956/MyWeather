//
//  SearchLocationViewModel.swift
//  Weather
//
//  Created by Миша Вашкевич on 13.04.2024.
//

import Foundation
import UIKit

protocol SearchLocationViewModelProtocol {

}

final class SearchLocationViewModel: SearchLocationViewModelProtocol {
    
    // MARK: Properties
    
    private let weatherNetworkManager: WeatherNetworkManagerProtocol
    private let coreDataManager: CoreDataManagerProtocol
    
    // MARK: lifeCycle
    
    init(weatherNetworkManager: WeatherNetworkManagerProtocol, coreDataManager: CoreDataManagerProtocol, places: [Place]) {
        self.weatherNetworkManager = weatherNetworkManager
        self.coreDataManager = coreDataManager
    }
}
