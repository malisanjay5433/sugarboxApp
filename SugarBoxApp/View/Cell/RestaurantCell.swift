//
//  RestaurantCell.swift
//  SugarBoxApp
//
//  Created by Sanjay Mali on 31/12/20.
//

import UIKit

final class RestaurantCell: UITableViewCell {
    
    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblCost: UILabel!
    @IBOutlet weak var backgroundview: UIView!
    
    func configureCell(restaurant: RestaurantData) {
        self.lblName.text = restaurant.name
        self.lblAddress.text = restaurant.location?.address ?? "City"
        self.lblCost.text = "Cost for 2 persons: \(restaurant.currency ?? "") \(restaurant.average_cost_for_two ?? 0)"
    }
}
