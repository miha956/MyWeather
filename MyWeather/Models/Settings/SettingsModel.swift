//
//  SettingsModel.swift
//  Weather
//
//  Created by Миша Вашкевич on 04.04.2024.
//

import Foundation

enum SettingsTitles: String, CaseIterable {
    case temperature = "Температура"
    case windSpeed = "Скорость ветра"
    case timeFormat = "Формат времени"
}

enum SettingsOptions: CaseIterable {
    
    case temperature
    case windSpeed
    case timeFormat
    
    var options: [String] {
        switch self {
        case .temperature:
            return Temperature.allCases.map { $0.value }
        case .windSpeed:
            return WindSpeed.allCases.map { $0.value }
        case .timeFormat:
            return TimeFormat.allCases.map { $0.value }
        }
    }
}



struct SettingsModel {
    
    let viewTitle = "Настройки"
    let settingsTitle = SettingsTitles.allCases
    let optionsTitles = SettingsOptions.allCases
    let buttonTitle = "Установить"
    

}
