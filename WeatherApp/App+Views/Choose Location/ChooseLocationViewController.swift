//
//  ChooseLocationViewController.swift
//  WeatherApp
//
//  Created by Juan Garcia on 12/17/18.
//  Copyright © 2018 Juan Garcia. All rights reserved.
//

import UIKit

protocol ChooseLocationViewControllerDelegate: class {
}

class ChooseLocationViewController: UIViewController {
    
    let viewModel = ChooseLocationViewModel()
    weak var delegate: ChooseLocationViewControllerDelegate? = nil
    
    @IBOutlet var tableView: UITableView!
    lazy var searchBar = UISearchBar(frame: CGRect.zero)
    
    //MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSearchBarInNavigationBar()
    }
    
    //MARK: View setup
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
}

// MARK: - Table view data source
extension ChooseLocationViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
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
        
        switch indexPath.section {
        case 0:
            cell.titleLabel.text = .currentLocation
            cell.subtitleLabel.text = ""
        case 1:
            let recentLocation = viewModel.recentLocation[indexPath.row]
            
            cell.titleLabel.text = recentLocation.cityName
            cell.subtitleLabel.text = recentLocation.country
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return .recents
        default:
            return nil
        }
    }
}

// MARK: - Table view delegate
extension ChooseLocationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Search bar delegate
extension ChooseLocationViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true)
    }
}
