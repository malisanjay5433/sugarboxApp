//
//  APIConstants.swift
//  SugarBoxApp
//
//  Created by Sanjay Mali on 04/01/21.
//

import Foundation
import UIKit
struct AppConstantValues {
    static let constLocationChanged = "LocationChanged"
}

struct APIServerConstants {
    static let serverBaseURL = URL(string: "https://developers.zomato.com/api/v2.1/")!
    static let userKey = "8810681b9527918633f01be52e6f97b3"
    static let serverTimeout = 60.0
}

protocol Endpoint {
    
    var path: String { get }
    var reqType: String { get }
}
enum APIConstants {
    case restaurantsList(reqParams: String)
}
extension APIConstants: Endpoint {
    var path: String {
        switch self {
        case .restaurantsList(let params):
            return "search?\(params)"
    }
}
    var reqType: String {
        
        switch self {
        case .restaurantsList( _):
            return "GET"
        }
    }
}
