//
//  Parser.swift
//  weather-code-test
//
//  Created by Alexia Nunez on 1/12/18.
//  Copyright © 2018 Alexia Nunez. All rights reserved.
//

import Foundation

enum ParserError: Error {
    case MalformedData
    case NoData
}

struct Parser {
    
    func parseData(data: Data) throws -> Any? {
        
        guard
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
            let jsonDict = json as? [String: AnyObject],
            let cityData = City(jsonData: jsonDict)
            else {
                throw ParserError.MalformedData
        }
        
        return cityData
    }
}
