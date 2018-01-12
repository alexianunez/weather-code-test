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
    }
    
    let name: String
    let id: Int
    let visibility: Int
    var weather: [Weather] = []
    
    init?(jsonData: [String: Any]) {
        guard
            let cityName = jsonData[Keys.name.rawValue] as? String,
            let cityId = jsonData[Keys.id.rawValue] as? Int,
            let cityVisibility = jsonData[Keys.visibility.rawValue] as? Int,
            let weatherJson = jsonData[Keys.weather.rawValue] as? [[String: Any]]
            else {
                return nil
        }
        self.name = cityName
        self.id = cityId
        self.visibility = cityVisibility
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

