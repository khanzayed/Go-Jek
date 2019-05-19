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
            return "https://gojek-contacts-app.herokuapp.com"
        }
    }
    
    fileprivate func getHeaders() -> [String:String] {
        return [
            "Content-Type"      :   "application/json"
        ]
    }
    
    //MARK: API Calls
    internal func request(_ url: String, method: HTTPMethod, parameters: [String:Any]?, completion: @escaping (Response) -> Void) {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = getHeaders()
        
        if let params = parameters {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
                request.httpBody = jsonData
            } catch let _ {
                let reponse = Response(jsonResponse: nil, statusCode: .PARSING_ERROR)
                completion(reponse)
                
                return
            }
        }
        
        print("\n")
        printCURLRequest(url: url, params: parameters, method: method)
        
        let dataRequest = URLSession.shared.dataTask(with: request) { (responseData, urlResponse, error) in
            print("Response of API -> \(url) \n")
            
            if let err = error {
                print(err.localizedDescription)
                let reponse = Response(jsonResponse: nil, statusCode: .ERROR)
                completion(reponse)
            } else if let data = responseData {
                let statusCode = StatusCode(rawValue: (urlResponse as! HTTPURLResponse).statusCode)
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                    
                    let reponse = Response(jsonResponse: jsonResponse, statusCode: statusCode)
                    completion(reponse)
                } catch let _ {
                    let reponse = Response(jsonResponse: nil, statusCode: .PARSING_ERROR)
                    completion(reponse)
                }
            }
        }
        dataRequest.resume()
    }
    
    internal func getData(fromURLStr url: String, completion: @escaping (Data?) -> Void) {
        let url = URL(string: url)!
        
        let dataRequest = URLSession.shared.dataTask(with: url, completionHandler: { (responseData, urlResponse, error) in
            if let _ = error {
                completion(nil)
            } else if let data = responseData {
                completion(data)
            }
        })
        dataRequest.resume()
    }
}

extension APIHandler {
    
    fileprivate func printCURLRequest(url:String, params:[String:Any]?, method: HTTPMethod) {
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
    case PUT
    case DELETE
}

enum StatusCode: Int {
    case SUCCESS = 200
    case VALIDATION_ERROR = 422
    case NOT_FOUND = 404
    case INTERNAL_SERVER_ERROR = 500
    case ERROR = 600
    case PARSING_ERROR = 700
}


struct Response {
    
    var json: Any?
    var statusCode: StatusCode?
    
    init(jsonResponse: Any?, statusCode: StatusCode?) {
        self.json = jsonResponse
        self.statusCode = statusCode
    }
    
}
