//
//  Coordinator.swift
//  WeatherApp
//
//  Created by Juan Garcia on 12/16/18.
//  Copyright © 2018 Juan Garcia. All rights reserved.
//

import UIKit

final class Coordinator {
    
    let navigationController: UINavigationController
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.loadViewIfNeeded()
        
        let weatherVC = navigationController.viewControllers.first as! WeatherViewController
        weatherVC.delegate = self
    }
    
    func update(_ location: Location) {
        let weatherVC = navigationController.viewControllers.first as! WeatherViewController
        weatherVC.viewModel.getCurrentWeather(for: location)
    }
}

extension Coordinator: WeatherViewControllerDelegate {
    
    func showChooseLocationView() {
        let chooseLocationNC = storyboard.instantiateChooseLocationNavigationController(with: self)
        navigationController.present(chooseLocationNC, animated: true)
    }
}

extension Coordinator: ChooseLocationViewControllerDelegate {
    
    func didSelect(_ location: Location) {
        update(location)
        
        navigationController.dismiss(animated: true)
    }
}

extension UIStoryboard {
    
    func instantiateChooseLocationNavigationController(with delegate: ChooseLocationViewControllerDelegate) -> UINavigationController {
        let chooseLocationNC = instantiateViewController(withIdentifier: "chooseLocationNavigationController") as! UINavigationController
        
        let chooseLocationVC = chooseLocationNC.viewControllers.first as! ChooseLocationViewController
        chooseLocationVC.delegate = delegate
        
        return chooseLocationNC
    }
}
