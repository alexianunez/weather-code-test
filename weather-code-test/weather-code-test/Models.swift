//
//  Models.swift
//  weather-code-test
//
//  Created by Alexia Nunez on 1/12/18.
//  Copyright © 2018 Alexia Nunez. All rights reserved.
//

import Foundation

struct APIWrapper {
    
}

struct City {
    
    private enum Keys: String {
        case name
        case id
        case weather
        case visibility
        case main
    }
    
    let name: String
    let id: Int
    let visibility: Int
    var weather: [Weather] = []
    let secondaryWeather: SecondaryWeather
    
    init?(jsonData: [String: Any]) {
        guard
            let cityName = jsonData[Keys.name.rawValue] as? String,
            let cityId = jsonData[Keys.id.rawValue] as? Int,
            let cityVisibility = jsonData[Keys.visibility.rawValue] as? Int,
            let weatherJson = jsonData[Keys.weather.rawValue] as? [[String: Any]],
            let secondaryWeatherJson = jsonData[Keys.main.rawValue] as? [String: Any],
            let secondaryWeather = SecondaryWeather(jsonData: secondaryWeatherJson)
            else {
                return nil
        }
        self.name = cityName
        self.id = cityId
        self.visibility = cityVisibility
        self.secondaryWeather = secondaryWeather
        
        let _ = weatherJson.map { (weatherInfo) in
            if let weatherStruct = Weather(jsonData: weatherInfo) {
                self.weather.append(weatherStruct)
            }
        }
    }
    
}

struct Weather {

    private enum Keys: String {
        case weather
        case id
        case name
        case shortDesc = "main"
        case detailDesc = "description"
        case icon
    }

    let id: Int
    let shortDesc: String
    let detailDesc: String
    let icon: String

    init?(jsonData: [String: Any]) {
        guard
            let id = jsonData[Keys.id.rawValue] as? Int,
            let shortDesc = jsonData[Keys.shortDesc.rawValue] as? String,
            let detailDesc = jsonData[Keys.detailDesc.rawValue] as? String,
            let icon = jsonData[Keys.icon.rawValue] as? String
            else {
                return nil
        }
        self.id = id
        self.shortDesc = shortDesc
        self.detailDesc = detailDesc
        self.icon = icon
    }
}

struct SecondaryWeather {
    
    private enum Keys: String {
        case humidity
        case currentTemp = "temp"
        case lowTemperature = "temp_min"
        case highTemperature = "temp_max"
    }
    
    let humidity: Int
    let currentTemperature: Float
    let lowTemperature: Float
    let highTemperature: Float
    
    init?(jsonData: [String: Any]) {
        guard
            let humidity = jsonData[Keys.humidity.rawValue] as? Int,
            let currentTemp = jsonData[Keys.currentTemp.rawValue] as? Float,
            let highTemp = jsonData[Keys.highTemperature.rawValue] as? Float,
            let lowTemp = jsonData[Keys.lowTemperature.rawValue] as? Float
            else {
                return nil
        }
        self.humidity = humidity
        self.currentTemperature = currentTemp
        self.highTemperature = highTemp
        self.lowTemperature = lowTemp
        
    }
    
    
}

