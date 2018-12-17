//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Juan Garcia on 12/16/18.
//  Copyright © 2018 Juan Garcia. All rights reserved.
//

import UIKit

protocol WeatherViewControllerDelegate: class {
    func showChooseLocationView()
}

class WeatherViewController: UIViewController {
    
    let viewModel = WeatherViewModel()
    weak var delegate: WeatherViewControllerDelegate? = nil
    
    @IBOutlet var tableView: UITableView!
    
    //MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        title = .loading
        
        viewModel.getCurrentLocation()
    }
}

fileprivate extension String {
    static let loading = NSLocalizedString("Loading...", comment: "Title for navigation bar")
}

// MARK: - Action buttons
extension WeatherViewController {

    @IBAction func chooseLocationButtonAction(_ sender: UIBarButtonItem) {
        if let delegate = delegate {
            delegate.showChooseLocationView()
        }
    }
}

// MARK: - Table view data source
extension WeatherViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
