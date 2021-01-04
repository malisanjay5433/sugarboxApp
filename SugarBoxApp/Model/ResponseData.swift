//
//  ResponseData.swift
//  SugarBoxApp
//
//  Created by Sanjay Mali on 02/01/21.
//

import UIKit

struct ResponseData {
    
    fileprivate var data: Data
    init(data: Data) {
        self.data = data
    }
}

extension ResponseData {
    
    public func decode<T: Codable>(_ type: T.Type) -> (decodedData: T?, error: Error?) {
        
        let jsonDecoder = JSONDecoder()
        do {
            let response = try  jsonDecoder.decode(T.self, from: data)
            return (response, nil)
        }
        catch let error {
            print(error.localizedDescription)
            return (nil, error)
        }
    }
}
