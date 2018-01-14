//
//  ViewController.swift
//  weather-code-test
//
//  Created by Alexia Nunez on 1/12/18.
//  Copyright © 2018 Alexia Nunez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cityInfoLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    fileprivate let datasource: Datasource = Datasource()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let lastCitySearched = datasource.retrieveLastSearch() {
            searchBar.text = lastCitySearched
            datasource.fetchData(searchTerm: lastCitySearched) { [weak self] (dataResponse) in
                self?.processDatasourceResponse(response: dataResponse)
            }
        }
    }

}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        searchBar.resignFirstResponder()

        if let searchTerm = searchBar.text {
            fetchData(searchTerm: searchTerm)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }

}

private extension ViewController {
    
    func fetchData(searchTerm: String) {
        
        clearCityInfoText()
        hideErrorLabel()
        iconImageView.image = nil
        
        datasource.fetchData(searchTerm: searchTerm) { [weak self] (dataResponse) in
            self?.processDatasourceResponse(response: dataResponse)
        }
    }
    
    func processDatasourceResponse(response: DatasourceResponse) {
        guard
            response.1 == nil,
            let city = response.0
            else {
                showErrorLabel(message: response.1?.localizedDescription ?? "No data available. Please try again")
                return
        }
        populateUI(city: city)
    }
    
    func populateUI(city: City) {
        DispatchQueue.main.async { [weak self] in
            self?.cityInfoLabel.text = self?.createCityInfoText(city: city)
            self?.temperatureLabel.text = self?.createTemperatureText(city: city)
            self?.fetchWeatherImage(city: city, completion: { (image) in
                if let img = image {
                    DispatchQueue.main.async {
                        self?.iconImageView.image = img
                    }
                }
            })
        }
    }
    
    func showErrorLabel(message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.errorLabel.text = message
            self?.errorLabel.isHidden = false
        }
    }
    
    func hideErrorLabel() {
        DispatchQueue.main.async { [weak self] in
            self?.errorLabel.isHidden = true
        }
    }
    
    func clearCityInfoText() {
        DispatchQueue.main.async { [weak self] in
            self?.cityInfoLabel.text = ""
            self?.temperatureLabel.text = ""
        }
    }
    
    func createCityInfoText(city: City) -> String {
        
        var bodyText: String = "\(city.name)\n"
        bodyText.append("Current temperature: \(city.secondaryWeather.currentTemperature)\n\n")
        bodyText.append("High: \(city.secondaryWeather.highTemperature)\n")
        bodyText.append("Low: \(city.secondaryWeather.lowTemperature)\n")
        if let v = city.visibility {
            bodyText.append("Humidity: \(v)%")
        }
        
        return bodyText
    }
    
    func createTemperatureText(city: City) -> String? {
        guard let weather = city.weather.first else {
            return nil
        }
        var tempText: String = "Currently: \(weather.shortDesc)\n"
        tempText.append("\(weather.detailDesc)")
        
        return tempText
    }
    
    func fetchWeatherImage(city: City, completion: @escaping (UIImage?)->())  {
        guard let weatherData = city.weather.first else {
            completion(nil)
            return
        }
        datasource.fetchCityImage(imgName: weatherData.icon) { (image) in
            completion(image)
            return
        }
    }
}

