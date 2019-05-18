//
//  AppDataModel.swift
//  GoJekContactApp
//
//  Created by Faraz on 18/05/19.
//  Copyright © 2019 Faraz. All rights reserved.
//

import Foundation

class AppDataModel {
    
    var errMessage: String?
    var list: [[String:Any]]? // If the response is in form of array
    var details: [String:Any]? // If the response is in form of dictionary
    
    init(_ jsonResponse: Any?, errorMessage: String?) {
        if let str = errorMessage  {
            errMessage = str
            
            return
        }
        
        if let list = jsonResponse as? [[String:Any]] {
            self.list = list
        } else if let details = jsonResponse as? [String:Any] {
            self.details = details
        } else {
            errMessage = "Response structure error"
        }
    }
    
}
