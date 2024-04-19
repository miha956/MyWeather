//
//  IntWeatherCodeExtention.swift
//  Weather
//
//  Created by Миша Вашкевич on 14.04.2024.
//

import Foundation

public extension Int {
    //дописать коды
    var weatherCodeDescription: String {
        guard let userLanguage = Locale.preferredLanguages.first else { return "error"}
        let weatherCode = self
        if userLanguage.hasPrefix("ru") {
            let weatherDescriptionsRu: [Int:String] = [
                0:"Ясно",
                1:"Преимущественно ясно",
                2:"Переменная облачность",
                3:"Пасмурно",
                45:"Туман",
                48:"Образование иния",
                51:"Небольшой дождь",
                53:"Умеренный дождь",
                55:"Сильный дождь",
                56:"Небольшой ледяной дождь",
                57:"Сильный ледяной дождь"
            ]
            if let description = weatherDescriptionsRu[weatherCode] {
                return description
            } else {
                return "Неправильный код погоды"
            }
        } else {
            let weatherDescriptionsEn: [Int:String] = [
                0:"Clear sky",
                1:"Mainly clear",
                2:"Partly cloudy",
                3:"Overcast",
                45:"Fog",
                48:"Depositing rime fog",
                51:"Light drizzle",
                53:"Moderate drizzle",
                55:"Dense intensity drizzle",
                56:"Light freezing drizzle",
                57:"Dense intensity freezing drizzle"
            ]
            if let description = weatherDescriptionsEn[weatherCode] {
                return description
            } else {
                return "wrong wetherCode"
            }
        }
    }
}
