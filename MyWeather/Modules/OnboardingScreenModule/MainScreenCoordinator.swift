//
//  MainScreenCoordinator.swift
//  Weather
//
//  Created by Миша Вашкевич on 08.04.2024.
//

import Foundation
import UIKit
import CoreData

class MainScreenCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    let networkManager = WeatherNetworkManager()
    let coreDataManaager = CoreDataManager()
    
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func goToSearchLocationView() {
        
    }
    
    func start() {
        let viewModel = LocationsPageViewModel(coreDataManager: coreDataManaager,
                                               networkManager: networkManager)
        viewModel.coordinator = self
        let viewController = LocationsPageView(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: true)
    }
    
    func showAddLocationView(places: [Place]) {
        let viewModel = SearchLocationViewModel(weatherNetworkManager: networkManager, 
                                                coreDataManager: coreDataManaager,
                                                places: places)
        let viewController = SearchLocationView(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
