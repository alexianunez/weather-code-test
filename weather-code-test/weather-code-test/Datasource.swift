//
//  Datasource.swift
//  weather-code-test
//
//  Created by Alexia Nunez on 1/12/18.
//  Copyright © 2018 Alexia Nunez. All rights reserved.
//

import Foundation

enum DatasourceError: Error {
    case EmptyString
    case NoData
}

typealias DatasourceResponse = (City?, Error?)

struct Datasource {
    
    private let restClient = RestClient()
    
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
            completion((city, nil))
        }
        
    }
    
}
