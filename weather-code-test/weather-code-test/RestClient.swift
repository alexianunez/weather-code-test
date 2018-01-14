//
//  RestClient.swift
//  EnvoyCodeTest
//
//  Created by Alexia Nunez on 1/10/18.
//  Copyright © 2018 Weather Code Test. All rights reserved.
//

typealias RestResponse = (Any?, Error?)

enum RestClientError: Error, CustomStringConvertible{
    case InvalidURL(String)
    case UnknownError
    case APIError(Error)
    case NoData
    
    var description: String {
        switch self {
        case .InvalidURL(let urlString): return "The URL \(urlString) was invalid."
        case .UnknownError: return "There was an unknown error."
        case .NoData: return "There was no data returned from the request."
        case .APIError(let error): return "The API returned an error: \(error)"
        }
    }
    
}

import Foundation

struct RestClient {
    
    private enum Keys: String {
        case AppID = "c810a7c1cce31283149bf4cb2e801add"
    }
    
    fileprivate let parser: Parser = Parser()
    fileprivate let apiURL = "https://api.openweathermap.org/data/2.5/weather?q="
    
    func fetchData(searchTerm: String, completion: @escaping (RestResponse) -> ()) -> Void {
        
        guard
            let fullURL = self.fullAPIURLString(searchTerm: searchTerm),
            let url: URL = self.urlForString(urlString: fullURL) else {
            completion((nil, RestClientError.InvalidURL(searchTerm)))
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { (data, response, error) in
            
            if let unwrappedError = error, let unwrappedResponse = response as? HTTPURLResponse, unwrappedResponse.statusCode != 200 {
                completion((nil, RestClientError.APIError(unwrappedError)))
                return
            }
            
            guard
                let unwrappedData = data,
                let result = try? self.parser.parseData(data: unwrappedData)
                else {
                    completion((nil, RestClientError.NoData))
                    return
            }
            
            completion((result, nil))
        }
        task.resume()
        
    }
    
    func fetchImageData(urlString: String, completion: @escaping (RestResponse) -> ()) -> Void {
        
        guard let url: URL = self.urlForString(urlString: urlString) else {
            completion((nil, RestClientError.InvalidURL(urlString)))
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { (data, response, error) in
            
            if let _ = error, let unwrappedResponse = response as? HTTPURLResponse, unwrappedResponse.statusCode != 200 {
                completion((nil, RestClientError.NoData))
                return
            }
            
            guard let unwrappedData: Data = data
                else {
                    completion((nil, RestClientError.UnknownError))
                    return
            }
            
            completion((unwrappedData, nil))
            
        }
        task.resume()
        
    }
    
    private func fullAPIURLString(searchTerm: String) -> String? {
        guard let encodedString = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return nil
        }
        
        return self.apiURL + encodedString + "&units=imperial&APPID=" + Keys.AppID.rawValue
    }
    
    private func urlForString(urlString: String) -> URL? {
        return URL(string: urlString)
    }
    
}




