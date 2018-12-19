//
//  WeatherConditionTableViewCell.swift
//  WeatherApp
//
//  Created by Juan Garcia on 12/19/18.
//  Copyright © 2018 Juan Garcia. All rights reserved.
//

import UIKit

class WeatherConditionTableViewCell: UITableViewCell {

    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var degreeSymbolLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
