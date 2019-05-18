//
//  APIHandler.swift
//  GoJekContactApp
//
//  Created by Faraz on 18/05/19.
//  Copyright © 2019 Faraz. All rights reserved.
//

import Foundation

class APIHandler: NSObject {
    
    internal var baseURL : String {
        get{
            return "http://gojek-contacts-app.herokuapp.com"
        }
    }
    
    fileprivate func getHeaders() -> [String:String] {
        return [
            "Content-Type"      :   "application/json"
        ]
    }
    
    //MARK: API Calls
    internal func request(_ url: String, method: HTTPMethod, parameters: [String:Any]?, completion: @escaping ([String:Any]?, String?) -> Void) {
        var request = URLRequest(url: URL(string: baseURL)!)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = getHeaders()
        
        if let params = parameters {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
                request.httpBody = jsonData
            } catch let parsingError {
                completion(nil, parsingError.localizedDescription)
                
                return
            }
        }
        
        
        URLSession.shared.dataTask(with: request) { (responseData, urlResponse, error) in
            if let err = error {
                completion(nil, err.localizedDescription)
            } else if let data = responseData {
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        completion(jsonResponse, nil)
                    } else {
                        completion(nil, "Response data is not in proper format")
                    }
                } catch let parsingError {
                    completion(nil, parsingError.localizedDescription)
                }
            }
        }
    }
}

extension APIHandler {
    
    internal func printCURLRequest(url:String, params:[String:Any]?, method: HTTPMethod) {
        var curlString = "THE CURL REQUEST:\n"
        curlString += "curl -X \(method) \\\n"
        
        getHeaders().forEach{(key, value) in
            let headerKey = self.escapeQuotesInString(str: key)
            let headerValue = self.escapeQuotesInString(str: value)
            curlString += " -H \'\(headerKey): \(headerValue)\' \n"
        }
        
        curlString += " \(url) \\\n"
        
        if let body = params {
            do {
                let data = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
                if let str = String(data: data, encoding: String.Encoding.utf8) {
                    let bodyDataString = self.escapeQuotesInString(str: str)
                    curlString += " -d \'\(bodyDataString)\'"
                }
            } catch _ {
                print("cURL Params Parsing Exception")
            }
        }
        
        print(curlString)
    }
    
    private func escapeQuotesInString(str:String) -> String {
        return str.replacingOccurrences(of: "\\", with: "")
    }
    
}

enum HTTPMethod : String {
    case GET
    case POST
    case DELETE
}


