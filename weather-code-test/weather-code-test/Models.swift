//
//  Models.swift
//  weather-code-test
//
//  Created by Alexia Nunez on 1/12/18.
//  Copyright © 2018 Alexia Nunez. All rights reserved.
//

import Foundation

typealias Serialization = [String: Any]

struct City {
    let name: String
    let id: Int
    var visibility: Int?
    var weather: [Weather] = []
    let secondaryWeather: SecondaryWeather
    let systemInfo: WeatherSystemInfo
    let coordinates: CityCoordinates
}

struct Weather {
    let id: Int
    let shortDesc: String
    let detailDesc: String
    let icon: String
}

struct SecondaryWeather {
    let humidity: Int
    let currentTemperature: Float
    let lowTemperature: Float
    let highTemperature: Float
}

struct WeatherSystemInfo {
    let id: Int
    let sunrise: Int
    let sunset: Int
}

struct CityCoordinates {
    let latitude: Double
    let longitude: Double
}

extension City {
    
    private enum Keys: String {
        case name
        case id
        case weather
        case visibility
        case main
        case sys
        case coord
    }
    
    init?(serialization: Serialization) {
        guard
            let cityName = serialization[Keys.name.rawValue] as? String,
            let cityId = serialization[Keys.id.rawValue] as? Int,
            let weatherJson = serialization[Keys.weather.rawValue] as? [[String: Any]],
            let secondaryWeatherJson = serialization[Keys.main.rawValue] as? Serialization,
            let secondaryWeather = SecondaryWeather(serialization: secondaryWeatherJson),
            let systemInfo = serialization[Keys.sys.rawValue] as? Serialization,
            let system = WeatherSystemInfo(serialization: systemInfo),
            let coords = serialization[Keys.coord.rawValue] as? Serialization,
            let cityCoords = CityCoordinates(serialization: coords)
        
            else {
                return nil
        }
        self.name = cityName
        self.id = cityId
        self.secondaryWeather = secondaryWeather
        self.systemInfo = system
        self.coordinates = cityCoords
        
        if let v = serialization[Keys.visibility.rawValue] as? Int {
            self.visibility = v
        }
        
        let _ = weatherJson.map { (weatherInfo) in
            if let weatherStruct = Weather(serialization: weatherInfo) {
                self.weather.append(weatherStruct)
            }
        }
    }
    
}

extension Weather {

    private enum Keys: String {
        case weather
        case id
        case name
        case shortDesc = "main"
        case detailDesc = "description"
        case icon
    }

    init?(serialization: Serialization) {
        guard
            let id = serialization[Keys.id.rawValue] as? Int,
            let shortDesc = serialization[Keys.shortDesc.rawValue] as? String,
            let detailDesc = serialization[Keys.detailDesc.rawValue] as? String,
            let icon = serialization[Keys.icon.rawValue] as? String
            else {
                return nil
        }
        self.id = id
        self.shortDesc = shortDesc
        self.detailDesc = detailDesc
        self.icon = icon
    }
}

extension SecondaryWeather {
    
    private enum Keys: String {
        case humidity
        case currentTemp = "temp"
        case lowTemperature = "temp_min"
        case highTemperature = "temp_max"
    }
    
    init?(serialization: Serialization) {
        guard
            let humidity = serialization[Keys.humidity.rawValue] as? Int,
            let currentTemp = serialization[Keys.currentTemp.rawValue] as? Float,
            let highTemp = serialization[Keys.highTemperature.rawValue] as? Float,
            let lowTemp = serialization[Keys.lowTemperature.rawValue] as? Float
            else {
                return nil
        }
        self.humidity = humidity
        self.currentTemperature = currentTemp
        self.highTemperature = highTemp
        self.lowTemperature = lowTemp
        
    }
}

extension WeatherSystemInfo {
    private enum Keys: String {
        case sunrise
        case sunset
        case id
    }
    
    init?(serialization: Serialization) {
        guard
            let id = serialization[Keys.id.rawValue] as? Int,
            let sunrise = serialization[Keys.sunrise.rawValue] as? Int,
            let sunset = serialization[Keys.sunset.rawValue] as? Int
            else {
                return nil
        }
        self.id = id
        self.sunrise = sunrise
        self.sunset = sunset
    }
}

extension CityCoordinates {
    private enum Keys: String {
        case lat
        case lon
    }
    
    init?(serialization: Serialization) {
        guard
            let lat = serialization[Keys.lat.rawValue] as? Double,
            let lon = serialization[Keys.lon.rawValue] as? Double
                else {
                    return nil
        }
        self.latitude = lat
        self.longitude = lon
    }
    
}

