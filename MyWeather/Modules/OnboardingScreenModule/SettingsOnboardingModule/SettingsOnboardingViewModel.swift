//
//  SettingsOnboardingViewModel.swift
//  Weather
//
//  Created by Миша Вашкевич on 04.04.2024.
//

import Foundation
import UIKit

protocol SettingsOnboardingViewModelProtocol {
    
    var viewContent: SettingsModel {get}
    var buttonTitle: String {get}
    var viewTitle: String {get}
    var currentSettings: [Int] {get set}
    
    func loadSettints()
    func segmentValueChanged(tag: Int, value: Int)
    func saveSettings()
    
    
}

final class SettingsOnboardingViewModel: SettingsOnboardingViewModelProtocol {    
    
    // MARK: Properties
    
    var userSettingsDataManager: UserSettingsDataManagerProtocol
    var coordinator: OnboardingCoordinator?
    
    // MARK: - DataSource
    
    var viewContent: SettingsModel {
        SettingsModel()
    }

    var viewTitle: String {
        return viewContent.viewTitle
    }
    
    var buttonTitle: String {
        return viewContent.buttonTitle
    }
    
    var currentSettings: [Int] = []
    
    init(userSettingsDataManager: UserSettingsDataManagerProtocol) {
        self.userSettingsDataManager = userSettingsDataManager
    }
    
    deinit {
        print("deinit SettingsOnboardingViewModel")
    }
    
    func loadSettints() {

        userSettingsDataManager.loadSettings { result in
            switch result {
            case .success(let settings):
                currentSettings.append(settings.temperature.rawValue)
                currentSettings.append(settings.windSpeed.rawValue)
                currentSettings.append(settings.timeFormat.rawValue)
            case .failure(_): break
            }
        }
    }
    
    func segmentValueChanged(tag: Int, value: Int) {
        currentSettings[tag] = value
    }
    
    func saveSettings() {
        var userSettings = UserAppSettings()
        userSettings.temperature = Temperature.allCases[currentSettings[0]]
        userSettings.windSpeed = WindSpeed.allCases[currentSettings[1]]
        userSettings.timeFormat = TimeFormat.allCases[currentSettings[2]]
        userSettingsDataManager.saveSettings(userAppSettings: userSettings)
        coordinator?.showMainView()
    }
}



