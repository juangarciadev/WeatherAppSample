//
//  WeatherDetailTableViewCell.swift
//  WeatherApp
//
//  Created by Juan Garcia on 12/19/18.
//  Copyright © 2018 Juan Garcia. All rights reserved.
//

import UIKit

class WeatherDetailTableViewCell: UITableViewCell {

    @IBOutlet var conditionTitleLabel
    : UILabel!
    @IBOutlet var valueLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
