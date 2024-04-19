//
//  Appoordinator.swift
//  Weather
//
//  Created by Миша Вашкевич on 08.04.2024.
//

import UIKit

class AppCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    
    var window: UIWindow
    let userSettingsDataManager: UserSettingsDataManager = UserSettingsDataManager()
    var navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        // set appereance navigationController
        return navigationController
    }()
    
    init(window: UIWindow) {
        self.window = window
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
    }
    
    deinit {
        print("deinit AppCoordinator")
    }
    
    func start() {
        userSettingsDataManager.loadSettings { result in
            switch result {
            case .success(let setting):
                let coordinator = MainScreenCoordinator(navigationController: navigationController)
                coordinator.start()
            case .failure(let error):
                let onboardingCoordinator = OnboardingCoordinator(navigationController: navigationController)
                onboardingCoordinator.start()
            }
        }
    }
}
