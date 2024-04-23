//
//  GeocodingModel.swift
//  MyWeather
//
//  Created by Миша Вашкевич on 23.04.2024.
//

import Foundation

// MARK: - Welcome
struct GeocodingModel: Codable {
    let response: Response
}

// MARK: - Response
struct Response: Codable {
    let geoObjectCollection: GeoObjectCollection

    enum CodingKeys: String, CodingKey {
        case geoObjectCollection = "GeoObjectCollection"
    }
}

// MARK: - GeoObjectCollection
struct GeoObjectCollection: Codable {
    let featureMember: [FeatureMember]
}

// MARK: - FeatureMember
struct FeatureMember: Codable {
    let geoObject: GeoObject

    enum CodingKeys: String, CodingKey {
        case geoObject = "GeoObject"
    }
}

// MARK: - GeoObject
struct GeoObject: Codable {
    let name: String
    let description: String?
    let point: Point

    enum CodingKeys: String, CodingKey {
        case name, description
        case point = "Point"
    }
}

// MARK: - Point
struct Point: Codable {
    let pos: String
}


