//
//  OnboardingCoordinator.swift
//  Weather
//
//  Created by Миша Вашкевич on 08.04.2024.
//

import Foundation
import UIKit

class OnboardingCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    deinit {
        print("deinit OnboardingCoordinator")
    }
    
    func start() {
        let viewModel = LocationOnboardingViewModel()
        viewModel.coordinator = self
        let viewController = LocationOnboardingView(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showSettingsView() {
        let userSittingsManager = UserSettingsDataManager()
        let viewModel = SettingsOnboardingViewModel(userSettingsDataManager: userSittingsManager)
        viewModel.coordinator = self
        let viewController = SettingsOnboardiingView(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    func showMainView() {
        let coordinator = MainScreenCoordinator(navigationController: navigationController)
        coordinator.start()
    }
    
}
