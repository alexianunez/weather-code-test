//
//  Parser.swift
//  weather-code-test
//
//  Created by Alexia Nunez on 1/12/18.
//  Copyright © 2018 Alexia Nunez. All rights reserved.
//

import Foundation

enum ParserError: Error, CustomStringConvertible {
    case MalformedData
    case NoData
    
    var description: String {
        switch self {
        case .MalformedData:
            return "There was an error processing the data. Please try again."
        case .NoData:
            return "There was no data to process. Please try again."
        }
    }
}

struct Parser {
    
    func parseData(data: Data) throws -> Any? {
        
        guard
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
            let jsonDict = json as? Serialization,
            let cityData = City(serialization: jsonDict)
            else {
                throw ParserError.MalformedData
        }
        
        if let str = String.init(data: data, encoding: .utf8) {
            print(str)
        }
        
        return cityData
    }
}
