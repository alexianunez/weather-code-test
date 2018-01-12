//
//  ViewController.swift
//  weather-code-test
//
//  Created by Alexia Nunez on 1/12/18.
//  Copyright © 2018 Alexia Nunez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
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
        fetchData()
    }

}

private extension ViewController {
    
    func fetchData() {
        
        let datasource: Datasource = Datasource()
        
        datasource.fetchData(searchTerm: "New Orleans") { [weak self] (dataResponse) in
            guard
                dataResponse.1 == nil,
                let city = dataResponse.0
                else {
                    return
            }
            DispatchQueue.main.async {
                self?.populateUI(city: city)
            }
        }
        
    }
    func populateUI(city: City) {
        
    }
}

