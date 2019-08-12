//
//  APIManager.swift
//  Votera
//
//  Created by Yashvardhan Mulki on 2019-08-12.
//  Copyright © 2019 Yashvardhan Mulki. All rights reserved.
//

import Foundation
import Alamofire

class APIManager: NSObject {
    
    enum APIError: Error {
        case noData
    }
    
    static func request(endpoint: String, completion: @escaping (_ response: Data?, _ error: Error?) -> Void) {
        AF.request(endpoint, method: .get, parameters: nil, encoding: JSONEncoding.default).validate(statusCode: 200...200)
            .validate(contentType: ["application/json"])
            .responseData { (response) in
                guard let data = response.data else {
                    completion(nil, APIError.noData)
                    return
                }
                completion(data, nil)
            }
    }
    
}
