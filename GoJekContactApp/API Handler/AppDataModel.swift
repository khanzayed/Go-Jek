//
//  AppDataModel.swift
//  GoJekContactApp
//
//  Created by Faraz on 18/05/19.
//  Copyright © 2019 Faraz. All rights reserved.
//

import Foundation

class AppDataModel {
    
    var statusCode: StatusCode!
    var errMessage: String?
    var list: [[String:Any]]? // If the response is in form of array
    var details: [String:Any]? // If the response is in form of dictionary
    
    init(_ response: Response) {
        if let code = response.statusCode {
            statusCode = code
            switch code {
            case .SUCCESS:
                if let list = response.json as? [[String:Any]] {
                    self.list = list
                } else if let details = response.json as? [String:Any] {
                    self.details = details
                }
            case .VALIDATION_ERROR:
                if let details = response.json as? [String:Any], let errors = details["errors"] as? [String], errors.count > 0 {
                    errMessage = errors[0]
                } else {
                    errMessage = "Error occurred"
                }
            case .INTERNAL_SERVER_ERROR:
                errMessage = "Internal Server Error occurred"
            case .ERROR:
                errMessage = "Error occurred"
            case .PARSING_ERROR:
                errMessage = "Parsing Error occurred"
            case .NOT_FOUND:
                errMessage = "URL not found"
            }
        } else {
            statusCode = .ERROR
            errMessage = "Error occurred"
        }
    }
    
}
