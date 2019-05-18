//
//  ContactsAPIHandler.swift
//  GoJekContactApp
//
//  Created by Faraz on 18/05/19.
//  Copyright © 2019 Faraz. All rights reserved.
//

import Foundation

class ContactsAPIHandler: APIHandler {
    
    override init() {
        
    }
    
    internal func getContacts(params: [String: Any]?, completion:  @escaping (ContactDataModel) -> Void) {
        let url = baseURL // append the end url here if required
        
        printCURLRequest(url: url, params: params, method: .GET)
        request(url, method: .GET, parameters: nil) { (jsonResponse, errorMessage) in
            print(jsonResponse ?? "BLANK")
        }
    }
    
}


/*
 ● API base URL​: ​http://gojek-contacts-app.herokuapp.com
 ● Documentation​: ​http://gojek-contacts-app.herokuapp.com/apipie/1.0/contacts
 ● Source code​: ​https://github.com/anagri/contacts-server
 ● Postman Collection:
 https://docs.google.com/document/d/1SroU6qiqkTTaON_5N3tl0p29ubrqcODB_LnqoYfM qRM/edit?usp=sharing
 */
