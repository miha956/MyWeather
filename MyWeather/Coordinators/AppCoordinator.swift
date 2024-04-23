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
        navigationController.navigationBar.tintColor = .appBlack
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
            case .success(_):
                let coordinator = MainScreenCoordinator(navigationController: navigationController)
                coordinator.start()
            case .failure(_):
                let onboardingCoordinator = OnboardingCoordinator(navigationController: navigationController)
                onboardingCoordinator.start()
            }
        }
    }
}
