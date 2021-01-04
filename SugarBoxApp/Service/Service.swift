//
//  Service.swift
//  SugarBoxApp
//
//  Created by Sanjay Mali on 29/12/20.
//  Copyright © 2020 theappmaker. All rights reserved.
//

import Foundation
import UIKit

let dictHeaders = ["Content-Type" : "application/json",
                   "Accept-Language" : "en-us",
                   "user-key" : APIServerConstants.serverKey]
protocol Networking {
    
    //MARK: Completion Handler
    typealias completionDataHandler<T> = (_ status: Bool, _ response: T?, _ errorMessage: Error?) -> Void
    typealias completionImageHandler = (_ status: Bool, _ response: UIImage?, _ error: Error?) -> Void
    func performNetworkRequest<T: Codable>(reqEndpoint: APIConstants, type: T.Type, completion: @escaping completionDataHandler<T>)
}

struct APINetworking: Networking {
    //MARK:- Perform Network Request
    func performNetworkRequest<T: Codable>(reqEndpoint: APIConstants, type: T.Type, completion: @escaping completionDataHandler<T>) {
        
        let urlString = APIServerConstants.serverBaseURL.appendingPathComponent(reqEndpoint.path).absoluteString.removingPercentEncoding
        guard let reqURL = URL(string: urlString ?? "") else {
            let error = APICustomError(title: "URL Error", desc: "URL is invalid.", code: 0, api: urlString ?? "")
            completion(false, nil, error)
            return
        }
        
        var urlRequest = URLRequest(url: reqURL)
        urlRequest.timeoutInterval = APIServerConstants.serverTimeout
        urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
        urlRequest.httpMethod = reqEndpoint.reqType
        
        //Headers
        for (key, value) in dictHeaders {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        let urlSession = URLSession.shared.dataTask(with: urlRequest) { (data, urlResponse, error) in
            guard let responseCode = urlResponse as? HTTPURLResponse else {
                let error = APICustomError(title: "Server Error", desc: "Something went wrong.", code: 0, api: urlString ?? "")
                completion(false, nil, error)
                return
            }
            if responseCode.statusCode != 200 {
                let error = APICustomError(title: "Server Error", code: responseCode.statusCode, api: urlString ?? "")
                completion(false, nil, error)
                return
            }
            guard let responseType = urlResponse?.mimeType, responseType == "application/json" else {
                let error = APICustomError(title: "Server Error", desc: "Invalid JSON.", code: 0, api: urlString ?? "")
                completion(false, nil, error)
                return
            }
            if let err = error {
                let error = APICustomError(title: "Data not found", desc: err.localizedDescription, code: 200, api: urlString ?? "")
                completion(false, nil, error)
                return
            }
            guard let data = data else {
                let error = APICustomError(title: "Data not found", desc: "Data not found", code: 200, api: urlString ?? "")
                completion(false, nil, error)
                return
            }
            let response = ResponseData(data: data)
            let decodedResponse = response.decode(type)
            guard let decodedData = decodedResponse.decodedData else {
                if let err = decodedResponse.error {
                    let error = APICustomError(title: "Data not decoded", desc: err.localizedDescription, code: 200, api: urlString ?? "")
                    completion(false, nil, error)
                    return
                }
                completion(false, nil, nil)
                return
            }
            //MARK: Valid Response
            completion(true, decodedData, nil)
        }
        urlSession.resume()
    }
}

