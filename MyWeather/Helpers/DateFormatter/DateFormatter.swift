//
//  DateFormatter.swift
//  Weather
//
//  Created by Миша Вашкевич on 15.04.2024.
//

import Foundation

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

public func getLocationTime(timeZone: TimeZone) -> String {
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = timeZone
    dateFormatter.dateFormat = "HH:mm"
    let locationTime = dateFormatter.string(from: currentDate)
    return locationTime
}
