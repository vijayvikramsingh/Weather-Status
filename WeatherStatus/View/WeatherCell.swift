//
//  WeatherCell.swift
//  WeatherStatus
//
//  Created by Vijay Singh on 25/07/16.
//  Copyright © 2016 Vijay Singh. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {

    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configCellWithData(data:WeatherData){
        self.title.text = data.title
        self.value.text = data.value
    }
}
