//
//  IntWeatherCodeExtention.swift
//  Weather
//
//  Created by Миша Вашкевич on 14.04.2024.
//

import Foundation

extension Int {
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
                48:"Образование инея",
                51:"Небольшая морось",
                53:"Умеренная морось",
                55:"Сильная морось",
                56:"Умеренная ледяная морось",
                57:"Сильная ледяная морось",
                61:"Небольшой дождь",
                63:"Умеренный дождь",
                65:"Сильный дождь",
                66:"Легкий ледяной дождь",
                67:"Сильный ледяной дождь",
                71:"Легкий снегопад",
                73:"Умеренный снегопад",
                75:"Сильный снегопад",
                77:"Град",
                80:"Легкий ливень",
                81:"Умеренный ливень",
                82:"Сильный ливень",
                85:"Легкий снегопад",
                86:"Сильный снегопад",
                95:"Гроза",
                96:"Гроза с легким градом",
                90:"Гроза с сильным градом"

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
                57:"Dense intensity freezing drizzle",
                61:"Slight rain",
                63:"Moderate rain",
                65:"Heavy intensity rain",
                66:"Light freezing rain",
                67:"Heavy intensity freezing rain",
                71:"Light snow fall",
                73:"Moderate snow fall",
                75:"Heavy intensity snow fall",
                77:"Snow grains",
                80:"Light rain shower",
                81:"Moderate Rain shower",
                82:"Heavy intensity Rain shower",
                85:"Light Snow shower",
                86:"Heavy Snow shower",
                95:"Thunderstorm",
                96:"Thunderstorm with light hail",
                90:"Thunderstorm with heavy hail"

            ]
            if let description = weatherDescriptionsEn[weatherCode] {
                return description
            } else {
                return "wrong wetherCode"
            }
        }
    }
}
