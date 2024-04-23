//
//  UserSettingsDataManager.swift
//  Weather
//
//  Created by Миша Вашкевич on 05.04.2024.
//

import Foundation

enum UserSettingsDatabaseErrors: Error {
    case loadDataError
    case decodeSettingsError
    case encodeSettingsError
    case saveDataError
    
    var errorDescription: String {
        switch self {
        case .loadDataError:
            return "ошибка загрузки настроек"
        case .decodeSettingsError:
            return "ошибка декодирования настроек"
        case .encodeSettingsError:
            return "ошибка кодирования настроек"
        case .saveDataError:
            return "ошибка сохранения настроек"
        }
    }
}

protocol UserSettingsDataManagerProtocol {

    
    func loadSettings(completion: (Result<UserAppSettings, UserSettingsDatabaseErrors>) -> Void)
    func saveSettings(userAppSettings: UserAppSettings)
}

final class UserSettingsDataManager: UserSettingsDataManagerProtocol {
    
    

    
    func loadSettings(completion: (Result<UserAppSettings, UserSettingsDatabaseErrors>) -> Void){
        guard let data = UserDefaults.standard.data(forKey: "settingsDatabase") else {
            completion(.failure(.loadDataError))
            let userAppSettings = UserAppSettings()
            saveSettings(userAppSettings: userAppSettings)
            return
        }
        do {
            let settings = try JSONDecoder().decode(UserAppSettings.self, from: data)
            completion(.success(settings))
        } catch {
            completion(.failure(.decodeSettingsError))
        }
    }
    
    func saveSettings(userAppSettings: UserAppSettings) {
        do {
            let data = try JSONEncoder().encode(userAppSettings)
            UserDefaults.standard.set(data, forKey: "settingsDatabase")
        } catch let error {
            print("encode error \(error)")
        }
    }
}
