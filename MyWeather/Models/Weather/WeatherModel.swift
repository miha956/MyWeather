//
//  WeatherModels.swift
//  Weather
//
//  Created by Миша Вашкевич on 09.04.2024.
//

import Foundation

// MARK: - Welcome
struct WeatherModel: Codable {
    let latitude, longitude, generationtimeMS: Double
    let utcOffsetSeconds: Int
    let timezone, timezoneAbbreviation: String
    let elevation: Int
    let currentUnits: CurrentUnits
    let current: Current
    let hourlyUnits: HourlyUnits
    let hourly: Hourly
    let dailyUnits: DailyUnits
    let daily: Daily

    enum CodingKeys: String, CodingKey {
        case latitude, longitude
        case generationtimeMS = "generationtime_ms"
        case utcOffsetSeconds = "utc_offset_seconds"
        case timezone
        case timezoneAbbreviation = "timezone_abbreviation"
        case elevation
        case currentUnits = "current_units"
        case current
        case hourlyUnits = "hourly_units"
        case hourly
        case dailyUnits = "daily_units"
        case daily
    }
}

// MARK: - Current
struct Current: Codable {
    let time: String
    let interval: Int
    let temperature, apparentTemperature: Double
    let relativeHumidity, isDay: Int
    let precipitation: Double
    let weatherCode, cloudCover: Int
    let surfacePressure: Double

    enum CodingKeys: String, CodingKey {
        case time, interval
        case temperature = "temperature_2m"
        case relativeHumidity = "relative_humidity_2m"
        case apparentTemperature = "apparent_temperature"
        case isDay = "is_day"
        case precipitation
        case weatherCode = "weather_code"
        case cloudCover = "cloud_cover"
        case surfacePressure = "surface_pressure"
    }
}

// MARK: - CurrentUnits
struct CurrentUnits: Codable {
    let time, interval, temperature, relativeHumidity: String
    let apparentTemperature, isDay, precipitation, weatherCode: String
    let cloudCover, surfacePressure: String

    enum CodingKeys: String, CodingKey {
        case time, interval
        case temperature = "temperature_2m"
        case relativeHumidity = "relative_humidity_2m"
        case apparentTemperature = "apparent_temperature"
        case isDay = "is_day"
        case precipitation
        case weatherCode = "weather_code"
        case cloudCover = "cloud_cover"
        case surfacePressure = "surface_pressure"
    }
}

// MARK: - Daily
struct Daily: Codable {
    let time: [String]
    let weatherCode: [Int]
    let temperatureMax: [Double]
    let temperatureMin: [Double]
    let sunrise, sunset: [String]
    let daylightDuration, sunshineDuration, precipitationSum: [Double]
    let precipitationProbabilityMax: [Int?]

    enum CodingKeys: String, CodingKey {
        case time
        case weatherCode = "weather_code"
        case temperatureMax = "temperature_2m_max"
        case temperatureMin = "temperature_2m_min"
        case sunrise, sunset
        case daylightDuration = "daylight_duration"
        case sunshineDuration = "sunshine_duration"
        case precipitationSum = "precipitation_sum"
        case precipitationProbabilityMax = "precipitation_probability_max"
    }
}

// MARK: - DailyUnits
struct DailyUnits: Codable {
    let time, weatherCode, temperatureMax, temperatureMin: String
    let sunrise, sunset, daylightDuration, sunshineDuration: String
    let precipitationSum, precipitationProbabilityMax: String

    enum CodingKeys: String, CodingKey {
        case time
        case weatherCode = "weather_code"
        case temperatureMax = "temperature_2m_max"
        case temperatureMin = "temperature_2m_min"
        case sunrise, sunset
        case daylightDuration = "daylight_duration"
        case sunshineDuration = "sunshine_duration"
        case precipitationSum = "precipitation_sum"
        case precipitationProbabilityMax = "precipitation_probability_max"
    }
}

// MARK: - Hourly
struct Hourly: Codable {
    let time: [String]
    let temperature: [Double]
    let relativeHumidity: [Int]
    let apparentTemperature: [Double]
    let precipitationProbability: [Int?]
    let weatherCode: [Int]
    let surfacePressure: [Double]
    let cloudCover: [Int]

    enum CodingKeys: String, CodingKey {
        case time
        case temperature = "temperature_2m"
        case relativeHumidity = "relative_humidity_2m"
        case apparentTemperature = "apparent_temperature"
        case precipitationProbability = "precipitation_probability"
        case weatherCode = "weather_code"
        case surfacePressure = "surface_pressure"
        case cloudCover = "cloud_cover"
    }
}

// MARK: - HourlyUnits
struct HourlyUnits: Codable {
    let time, temperature, relativeHumidity, apparentTemperature: String
    let precipitationProbability, weatherCode, surfacePressure, cloudCover: String

    enum CodingKeys: String, CodingKey {
        case time
        case temperature = "temperature_2m"
        case relativeHumidity = "relative_humidity_2m"
        case apparentTemperature = "apparent_temperature"
        case precipitationProbability = "precipitation_probability"
        case weatherCode = "weather_code"
        case surfacePressure = "surface_pressure"
        case cloudCover = "cloud_cover"
    }
}

