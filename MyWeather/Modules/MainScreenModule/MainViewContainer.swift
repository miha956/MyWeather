//
//  MainViewContainer.swift
//  MyWeather
//
//  Created by Миша Вашкевич on 02.05.2024.
//

import Foundation
import SideMenu
import UIKit

final class MainViewContainer {
    
    private var coreDataManager: CoreDataManagerProtocol
    private var networkManager: WeatherNetworkManagerProtocol
    private let userSettingsDataManager: UserSettingsDataManager
    private var userSettings: UserAppSettings?
    var coordinator: MainScreenCoordinator?
    
    init(coreDataManager: CoreDataManagerProtocol, networkManager: WeatherNetworkManagerProtocol, userSettingsDataManager: UserSettingsDataManager) {
        self.coreDataManager = coreDataManager
        self.networkManager = networkManager
        self.userSettingsDataManager = userSettingsDataManager
        fetchSettings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fetchSettings() {
        userSettingsDataManager.loadSettings { [weak self] result in
            switch result {
            case .success(let settings):
                self?.userSettings = settings
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getSideMenuController() -> UIViewController? {
        
        guard let userSettings = userSettings else { return nil}
        
        let pageViewModel = LocationsPageViewModel(coreDataManager: coreDataManager,
                                               networkManager: networkManager,
                                               userSettings: userSettings)
        pageViewModel.coordinator = coordinator
        let pageViewController = LocationsPageViewController(viewModel: pageViewModel)
        
        let menuViewModel = SideMenuViewModel(weatherNetworkManager: networkManager,
                                              coreDataManager: coreDataManager,
                                              userSettings: userSettings)
        menuViewModel.delegate = pageViewModel
        let menuViewController = SideMenuViewController(viewModel: menuViewModel)
        let sideMenuController = SideMenuController(contentViewController: pageViewController, menuViewController: menuViewController)
        SideMenuController.preferences.basic.menuWidth = 270
        SideMenuController.preferences.basic.enablePanGesture = false
        return sideMenuController
    }
}
