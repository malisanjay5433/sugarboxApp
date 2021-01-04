//
//  searchDataModel.swift
//  SugarBoxApp
//
//  Created by Sanjay Mali on 02/01/21.
//

import Foundation
struct LocationData: Codable {
    var address: String?
    var city: String?
    var locality_verbose: String?
}
struct RestaurantData: Codable {
    var id: String
    var name: String?
    var location: LocationData?
    var cuisines: String?
    var average_cost_for_two: Int?
    var currency: String?
    var thumb: String?
    var featured_image: String?
    var phone_numbers: String?
}

struct RestaurantsMainData: Codable {
    
    var restaurant: RestaurantData
}

struct AllRestaurantsData: Codable {
    
    var restaurants: [RestaurantsMainData]
    var results_found: Int
}
