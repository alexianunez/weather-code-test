//
//  Datasource.swift
//  weather-code-test
//
//  Created by Alexia Nunez on 1/12/18.
//  Copyright © 2018 Alexia Nunez. All rights reserved.
//

import Foundation
import UIKit

enum DatasourceError: Error, CustomStringConvertible {
    case EmptyString
    case NoData
    
    var description: String {
        switch self {
        case .EmptyString:
            return "Search query is empty. Please try with a larger search query."
        case .NoData:
            return "There was no data available. Please try again later."
        }
    }
}

typealias DatasourceResponse = (City?, Error?)

struct Datasource {
    
    private let restClient = RestClient()
    internal let cityKey = "cityKey"
    
    func fetchData(searchTerm: String, completion: @escaping (DatasourceResponse) -> ()) -> Void {
        guard searchTerm.count > 0
            else {
                completion((nil, DatasourceError.EmptyString))
                return
        }
        
        restClient.fetchData(searchTerm: searchTerm) { (response) in
            guard response.1 == nil else {
                completion((nil, response.1))
                return
            }
            guard
                let city = response.0 as? City else {
                    completion((nil, DatasourceError.NoData))
                    return
            }
            self.persistLastSearch(city: city)
            completion((city, nil))
        }
        
    }
    
    func fetchCityImage(imgName: String, completion: @escaping (UIImage?) -> ()) {
        
        let imgUrl = "https://openweathermap.org/img/w/\(imgName).png"
        
        restClient.fetchImageData(urlString: imgUrl) { (response) in
            guard response.1 == nil, let imgData = response.0 as? Data, let img = UIImage(data: imgData)
                else {
                    completion(nil)
                    return
            }
            completion(img)
        }
        
    }
    
    func persistLastSearch(city: City) {
        UserDefaults.standard.set(city.name, forKey: cityKey)
    }
    
    func retrieveLastSearch() -> String? {
        return UserDefaults.standard.string(forKey: cityKey)
    }
    
}
