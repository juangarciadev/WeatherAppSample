//
//  Utilities.swift
//  WeatherApp
//
//  Created by Juan Garcia on 12/18/18.
//  Copyright © 2018 Juan Garcia. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func modalErrorAlert(title: String = .cannotGetWeather,
                         message: String? = nil,
                         accept: String = .ok,
                         callback: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: accept, style: .default) { _ in
            if let callback = callback {
                callback()
            }
        })
        present(alert, animated: true)
    }
}

fileprivate extension String {
    static let cannotGetWeather = NSLocalizedString("Cannot Get Weather", comment: "Title for error alert")
    static let ok = NSLocalizedString("OK", comment: "")
}
