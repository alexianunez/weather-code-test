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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //fetchData()
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
        
        let datasource: Datasource = Datasource()
        
        datasource.fetchData(searchTerm: searchTerm) { [weak self] (dataResponse) in
            guard
                dataResponse.1 == nil,
                let city = dataResponse.0
                else {
                    self?.showErrorLabel(message: dataResponse.1?.localizedDescription ?? "No data available. Please try again")
                    return
            }
            
            self?.populateUI(city: city)
            
        }
        
    }
    func populateUI(city: City) {
        DispatchQueue.main.async { [weak self] in
            self?.errorLabel.text = city.name
            self?.errorLabel.isHidden = false

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
}

