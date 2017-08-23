//
//  ArtRequests.swift
//  ArtPart
//
//  Created by Mihir Thanekar on 8/16/17.
//  Copyright © 2017 Mihir Thanekar. All rights reserved.
//

import Foundation

class ArtRequests {
    struct MailJetEmail {
        static let fromEmail = "artpart58@gmail.com"
        static let userName = "988d7d03fc9b6a724f2b663cd3f74703"
        static let passWord = "edca6cfeefcacb2720df6c7b7e84d9c7"
        static let sendURL = "https://api.mailjet.com/v3/send"
    }
    
    enum RequestType: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
    }
    
    static func requestWith(requestType: RequestType, requestURL: String, addValues: [String: String], httpBody: Data?, completionHandler: @escaping (Data?, Error?)-> Void) {
        
        let baseURL = URL(string: requestURL)!
        var request = URLRequest(url: baseURL)
        request.httpMethod = requestType.rawValue
        for value in addValues {
            request.addValue(value.value, forHTTPHeaderField: value.key)
        }
        
        request.httpBody = httpBody
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
            guard error == nil/*, let bytesData = data*/ else {
                completionHandler(nil, error)
                print("problem")
                print(error ?? "Something went wrong")
                return
            }
            
            completionHandler(data, error)
        })
        
        task.resume()
    }
    
    static func sendEmail(to email: String, subject: String, text: String) {
        let basicAuthID = "\(MailJetEmail.userName):\(MailJetEmail.passWord)" // Basic access auth uses method of name:password in base64 as string
        let encodedData = basicAuthID.data(using: .utf8)
        
        guard let encodedString = encodedData?.base64EncodedString() else {return}
        
        let vals = [
            "Content-Type": "application/json",
            "Authorization": "Basic \(encodedString)"
        ]
        
        let body = ["To": email,
                    "FromEmail": MailJetEmail.fromEmail,
                    "Subject": subject,
                    "Text-Part": text
        ]
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            return
        }
        
        
        requestWith(requestType: .post, requestURL: MailJetEmail.sendURL, addValues: vals, httpBody: httpBody, completionHandler: {
            (data, error) in
            guard error == nil else {
                // Analytics ...
                print(error?.localizedDescription ?? "Error sending email")
                return
            }
            
            let dataStr = String(data: data!, encoding: String.Encoding.utf8)
            print(dataStr ?? "ERORRRRRR")
        })
        
    }
    

}
