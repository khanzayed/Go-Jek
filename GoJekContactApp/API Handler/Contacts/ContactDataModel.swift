//
//  ContactDataModel.swift
//  GoJekContactApp
//
//  Created by Faraz on 18/05/19.
//  Copyright © 2019 Faraz. All rights reserved.
//

import Foundation

class ContactDataModel: AppDataModel {
    
    var contactsList:[Contact] = []
    
    override init(_ jsonResponse: Any, errorMessage: String?) {
        super.init(jsonResponse, errorMessage: errorMessage)
        
        if let list = super.list {
            contactsList = list.map{ Contact(withDetail: $0) }
        }
    }
    
}

struct Contact {
    
    var id: Int
    var firstName: String
    var lastName: String?
    var profilePicUrlStr: String?
    var isFavorite: Bool
    var contactURLStr: String?
    
    init(withDetail detail: [String: Any]) {
        id = detail["id"] as! Int
        firstName = detail["first_name"] as! String
        lastName = detail["last_name"] as? String
        profilePicUrlStr = detail["profile_pic"] as? String
        isFavorite = detail["favorite"] as? Bool ?? false
        contactURLStr = detail["url"] as? String
    }
    
}
