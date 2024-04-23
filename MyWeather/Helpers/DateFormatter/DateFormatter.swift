//
//  DateFormatter.swift
//  Weather
//
//  Created by Миша Вашкевич on 15.04.2024.
//

import Foundation
import CoreLocation

public extension String {
    
    var getHourFromDate: String {
        var result = String()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "HH"
            result = dateFormatter.string(from: date)
            
        }
        return result
    }
    
    var getWeekdayFromDate: String {
        var result = String()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: self) {
            dateFormatter.locale = Locale.preferredLanguages.first.flatMap(Locale.init(identifier:))
            dateFormatter.dateFormat = "EEEEE"
            result = dateFormatter.string(from: date)
            
        }
        return result
    }
}

func getLocalTime(latitude: String, longitude: String, completion: @escaping (Int) -> Void) {
    
    guard let lat = Double(latitude) else {return}
    guard let long = Double(longitude) else {return}
    let location = CLLocation(latitude: lat, longitude: long)
    let geocoder = CLGeocoder()
    geocoder.reverseGeocodeLocation(location) { placemarks, error in
        guard let placemark = placemarks?.first, let timeZone = placemark.timeZone else {
            completion(0)
            return
        }
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        dateFormatter.timeZone = timeZone
        let localHour = Int(dateFormatter.string(from: currentDate))!
        completion(localHour)
    }
}
