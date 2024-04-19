//
//  WeatherNetworkManager.swift
//  Weather
//
//  Created by Миша Вашкевич on 09.04.2024.
//

import Foundation
import CoreLocation


protocol WeatherNetworkManagerProtocol {
    
    func fetchWeatherData(latitude: String, longitude: String, temperatureUnit: String, complition: @escaping(Result<WeatherModel, Error>) -> Void)
}

final class WeatherNetworkManager: WeatherNetworkManagerProtocol {
    
    private enum ApiURL {
        case forcast
        case geocoding
        
        var baseURL: String {
            switch self {
            case .forcast:
                return "https://api.open-meteo.com/v1/forecast?"
            case .geocoding:
                return "https://geocoding-api.open-meteo.com/v1/search?"
            }
        }
    }
    
    enum Endpoint {
        case weather
        case deocoding
        
        fileprivate var requestParameters: String {
            switch self {
            case .weather:
                return "current=temperature_2m,relative_humidity_2m,apparent_temperature,is_day,precipitation,weather_code,cloud_cover,surface_pressure&hourly=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation_probability,weather_code,surface_pressure,cloud_cover&daily=weather_code,temperature_2m_max,temperature_2m_min,sunrise,sunset,daylight_duration,sunshine_duration,precipitation_sum,precipitation_probability_max&wind_speed_unit=ms&timezone=Europe%2FMoscow&forecast_days=10"
            case .deocoding:
                return "count=10&format=json"
            }
        }
        fileprivate var url: String {
            switch self {
            case .weather:
                return "\(ApiURL.forcast.baseURL)\(requestParameters)"
            case .deocoding:
                return "\(ApiURL.geocoding.baseURL)\(requestParameters)"
            }
        }
    }
    
    private func requestData(urlString: String, completion: @escaping(Result<Data, Error>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkMangerError.noConnection))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                    completion(.failure(error))
            }
            guard let data = data else { return }
                completion(.success(data))
        }
        .resume()
    }
    
    private func decodeData<T: Decodable>(urlString : String, response: @escaping(T?, Error?) -> Void) {

          self.requestData(urlString: urlString) { result in
            switch result {
              case .success(let data):
                  do {
                    let data = try JSONDecoder().decode(T.self, from: data)
                    response(data, nil)
                  } catch let jsonError {
                      response(nil, jsonError)
                  }
              case .failure(let error):
                  response(nil, error)
              }
          }
      }
    
    private func fetchData<T: Decodable>(url: String, complition: @escaping(Result<T, Error>) -> Void) {
        decodeData(urlString: url) { (data: T?, error) in
            if error != nil {
                complition(.failure(NetworkMangerError.decodeError))
            } else {
                guard let data = data else {
                    complition(.failure(NetworkMangerError.noData))
                    return
                }
                complition(.success(data))
            }
        }
    }
    
    //    let windSpeedUnit: WindSpeed
    //    let timeZone = ""
    //    let nubmerOfdays = ""
        // language
        
    
    func fetchWeatherData(latitude: String, longitude: String, temperatureUnit: String, complition: @escaping(Result<WeatherModel, Error>) -> Void) {
        let url = "\(Endpoint.weather.url)&latitude=\(latitude)&longitude=\(longitude)&temperature_unit=\(temperatureUnit)"
        fetchData(url: url, complition: complition)
    }
    
//    func fetchLocationGeocoding(name: String, complition: @escaping(Result<GeocodingLocationsModel, Error>) -> Void) {
//        let url = "\(Endpoint.deocoding.url)&name=\(name)"
//        fetchData(url: url, complition: complition)
//    }
}



