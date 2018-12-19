//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Juan Garcia on 12/16/18.
//  Copyright © 2018 Juan Garcia. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

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
            .subscribe(onNext: { [weak self] (weatherData) in
                self?.tableView.reloadData()
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
        return viewModel.rows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch WeatherRow(rawValue: indexPath.row) {
        case .condition?:
            let cell = tableView.dequeueReusableCell(withIdentifier: "weatherConditionCell", for: indexPath) as! WeatherConditionTableViewCell
            
            let info = viewModel.getCondition()
            
            //TODO: Move this logic to a fill method on the table view cell
            cell.tempLabel.text = "\(Int(info.temp ?? 0))"
            cell.descriptionLabel.text = info.description
            if let iconURL = info.iconURL {
                cell.iconImageView.kf.setImage(with: iconURL)
            }
            
            return cell
        case .mainData?:
            let cell = tableView.dequeueReusableCell(withIdentifier: "weatherMainDataCell", for: indexPath) as! WeatherMainDataTableViewCell
            
            let info = viewModel.getMainData()
            
            if let humidity = info.humidity {
                cell.humidityLabel.text = "💧 \(Int(humidity))%"
                cell.humidityLabel.isHidden = false
            } else {
                cell.humidityLabel.isHidden = true
            }
            if let tempMin = info.tempMin, let tempMax = info.tempMax {
                cell.temperatureLabel.text = "🌡 \(Int(tempMax))°/\(Int(tempMin))°"
                cell.temperatureLabel.isHidden = false
            } else {
                cell.temperatureLabel.isHidden = true
            }
            if let speed = info.windSpeed {
                cell.windLabel.text = "🌬 \(speed)/s"
                cell.windLabel.isHidden = false
            } else {
                cell.windLabel.isHidden = true
            }
            
            return cell
            
        case .detail?:
            let cell = tableView.dequeueReusableCell(withIdentifier: "weatherDetailCell", for: indexPath) as! WeatherDetailTableViewCell
            
            let info = viewModel.getDetail()
            
            if let title = info.conditionTitle {
                cell.conditionTitleLabel.text = title
            }
            if let value = info.value {
                cell.valueLabel.text = "\(value)"
            }
            
            return cell
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - Table view delegate
extension WeatherViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.getHeight(for: indexPath.row)
    }
}
