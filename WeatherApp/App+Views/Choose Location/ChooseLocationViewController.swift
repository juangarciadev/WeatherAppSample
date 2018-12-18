//
//  ChooseLocationViewController.swift
//  WeatherApp
//
//  Created by Juan Garcia on 12/17/18.
//  Copyright © 2018 Juan Garcia. All rights reserved.
//

import UIKit

protocol ChooseLocationViewControllerDelegate: class {
    func didSelect(_ location: Location)
}

class ChooseLocationViewController: UIViewController {
    
    let viewModel = ChooseLocationViewModel()
    weak var delegate: ChooseLocationViewControllerDelegate? = nil
    
    @IBOutlet var tableView: UITableView!
    lazy var searchBar = UISearchBar(frame: CGRect.zero)
    
    // MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSearchBarInNavigationBar()
    }
    
    // MARK: View setup
    func addSearchBarInNavigationBar() {
        searchBar.placeholder = .enterCity
        searchBar.sizeToFit()
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
    }
}

fileprivate extension String {
    static let enterCity = NSLocalizedString("Enter city", comment: "Placeholder for search bar")
    static let currentLocation = NSLocalizedString("Current Location", comment: "Title for locaiton cell")
    static let recents = NSLocalizedString("RECENTS", comment: "Title for section header")
    static let disabled = NSLocalizedString("Disabled", comment: "Subtitle for location cell")
}

// MARK: - Table view data source
extension ChooseLocationViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch LocationSections(rawValue: section) {
        case .current?:
            return 1
        case .recent?:
            return viewModel.recentLocation.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell  = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as? LocationTableViewCell else {
            assertionFailure("LocationTableViewCell must exist")
            return UITableViewCell()
        }
        
        switch LocationSections(rawValue: indexPath.section) {
        case .current?:
            cell.titleLabel.text = .currentLocation
            
            if let currentLocation = LocationManager.shared.location {
                cell.subtitleLabel.text = "\(currentLocation.city), \(currentLocation.country)"
            } else {
                cell.subtitleLabel.text = .disabled
            }
        case .recent?:
            let recentLocation = viewModel.recentLocation[indexPath.row]
            
            cell.titleLabel.text = recentLocation.city
            cell.subtitleLabel.text = recentLocation.country
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch LocationSections(rawValue: section) {
        case .recent?:
            return .recents
        default:
            return nil
        }
    }
}

// MARK: - Table view delegate
extension ChooseLocationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var locationSelected: Location? = nil
        switch LocationSections(rawValue: indexPath.section) {
        case .current?:
            if let currentLocation = LocationManager.shared.location {
                locationSelected = currentLocation
            }
        case .recent?:
            locationSelected = viewModel.recentLocation[indexPath.row]
        default:
            break
        }
        if let delegate = delegate, let location = locationSelected {
            delegate.didSelect(location)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Search bar delegate
extension ChooseLocationViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true)
    }
}
