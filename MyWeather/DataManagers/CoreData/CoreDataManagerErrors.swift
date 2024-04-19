//
//  CoreDataManagerErrors.swift
//  Weather
//
//  Created by Миша Вашкевич on 13.04.2024.
//

import Foundation

enum CoreDataManagerError {
    case locationAlreadyExist
    case fetchRequestError
    case saveDataError
}

extension CoreDataManagerError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .locationAlreadyExist:
            return "Location already exist"
        case .fetchRequestError:
            return "Fetch request error"
        case .saveDataError:
            return "Save data error"

        }
    }
}
