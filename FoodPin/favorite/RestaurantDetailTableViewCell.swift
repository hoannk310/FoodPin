//
//  RestaurantDetailTableViewCell.swift
//  FoodPin
//
//  Created by Apple on 11/9/20.
//

import UIKit

class RestaurantDetailTableViewCell: UITableViewCell {
    @IBOutlet var fieldLabel: UILabel!
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
