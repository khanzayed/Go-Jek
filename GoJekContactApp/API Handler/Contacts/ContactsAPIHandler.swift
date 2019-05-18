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
    
    internal func getContacts(completion:  @escaping (ContactsDataModel) -> Void) {
        let url = baseURL + "/contacts.json"
        
        request(url, method: .GET, parameters: nil) { (jsonResponse, errorStr) in
            let contactDataModel = ContactsDataModel(jsonResponse, errorMessage: errorStr)
            completion(contactDataModel)
        }
    }
    
    internal func getContactDetailsForPerson(userID: Int, completion:  @escaping (ContactDataModel) -> Void) {
        let url = baseURL + "/contacts/\(userID).json"
        
        request(url, method: .GET, parameters: nil) { (jsonResponse, errorStr) in
            let contactDataModel = ContactDataModel(jsonResponse, errorMessage: errorStr)
            completion(contactDataModel)
        }
    }
    
    internal func saveContact(params: [String:Any], completion:  @escaping (ContactDataModel) -> Void) {
        let url = baseURL + "/contacts.json"
        
        request(url, method: .POST, parameters: params) { (jsonResponse, errorStr) in
            let contactDataModel = ContactDataModel(jsonResponse, errorMessage: errorStr)
            completion(contactDataModel)
        }
    }
    
    internal func updateContact(params: [String:Any], completion:  @escaping (ContactDataModel) -> Void) {
        let url = baseURL + "/contacts.json"
        
        request(url, method: .PUT, parameters: params) { (jsonResponse, errorStr) in
            let contactDataModel = ContactDataModel(jsonResponse, errorMessage: errorStr)
            completion(contactDataModel)
        }
    }
    
}
