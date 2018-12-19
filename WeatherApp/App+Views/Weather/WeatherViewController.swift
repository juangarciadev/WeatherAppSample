//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Juan Garcia on 12/16/18.
//  Copyright © 2018 Juan Garcia. All rights reserved.
//

import UIKit
import RxSwift

protocol WeatherViewControllerDelegate: class {
    func showChooseLocationView()
}

class WeatherViewController: UIViewController {
    
    let viewModel = WeatherViewModel()
    weak var delegate: WeatherViewControllerDelegate? = nil
    let disposeBag = DisposeBag()
    
    @IBOutlet var tableView: UITableView!
    
    // MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = .loading

        
        viewModel.getCurrentLocation()
        addModelObservers()
        setupTableView()
        setupTransparentNavigationBar()
    }
    
    // MARK: View setup
    func addModelObservers() {
        viewModel.weatherDataObservable
            .subscribe(onNext: { (weatherData) in
                dump(weatherData)
            })
            .disposed(by: disposeBag)
        viewModel.locationObservable
            .subscribe(onNext: { [weak self] (location) in
                if let location = location {
                    self?.title = "\(location.city), \(location.country)"
                }
            })
            .disposed(by: disposeBag)
        viewModel.errorObservable
            .subscribe(onNext: { [weak self] (error) in
                self?.modalErrorAlert(message: error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func setupTableView() {
        tableView.tableFooterView = UIView()
    }
    
    func setupTransparentNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
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
