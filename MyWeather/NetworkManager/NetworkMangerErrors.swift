//
//  NetworkMangerErrors.swift
//  Weather
//
//  Created by Миша Вашкевич on 11.04.2024.
//

import Foundation

enum NetworkMangerError {
    case noConnection
    case noData
    case decodeError
}

extension NetworkMangerError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .noData: 
            return "Well, weird thing happens"
        case .noConnection:
            return "No Internet Connection"
        case .decodeError:
            return "ошибка декодирования"
        }
    }
}
