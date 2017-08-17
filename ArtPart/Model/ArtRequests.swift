//
//  ArtRequests.swift
//  ArtPart
//
//  Created by Mihir Thanekar on 8/16/17.
//  Copyright © 2017 Mihir Thanekar. All rights reserved.
//

import Foundation

class ArtRequests {
    static func requestWith(requestType: String, requestURL: String, addValues: [String: String], httpBody: String?, completionHandler: @escaping (Data?, Error?)-> Void) {
        
        let baseURL = URL(string: requestURL)!
        var request = URLRequest(url: baseURL)
        request.httpMethod = requestType
        for value in addValues {
            request.addValue(value.value, forHTTPHeaderField: value.key)
        }
        
        request.httpBody = httpBody?.data(using: String.Encoding.utf8)
        request.timeoutInterval = 10
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
            guard error == nil, let bytesData = data else {
                completionHandler(nil, error)
                print("problem")
                print(error ?? "Something went wrong")
                return
            }
            
            completionHandler(data, error)
        })
        
        task.resume()
    }
    
}
