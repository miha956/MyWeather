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
    let coreDataManager = CoreDataManager()
    let userSettingsDataManager = UserSettingsDataManager()
    
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func goToSearchLocationView() {
        
    }
    
    func start() {
        let mainContainer = MainViewContainer(coreDataManager: coreDataManager,
                                              networkManager: networkManager,
                                              userSettingsDataManager: userSettingsDataManager)
        mainContainer.coordinator = self
        let viewController = mainContainer.getSideMenuController()
        navigationController.setViewControllers([viewController!], animated: true)
    }
    
    func showAddLocationView(userSettings: UserAppSettings) {
        let viewModel = SearchLocationViewModel(weatherNetworkManager: networkManager, 
                                                coreDataManager: coreDataManager,
                                                userSettings: userSettings)
        viewModel.coordinator = self
        let viewController = SearchLocationViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
