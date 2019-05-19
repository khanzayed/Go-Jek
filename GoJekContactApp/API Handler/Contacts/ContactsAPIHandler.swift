//
//  ContactsAPIHandler.swift
//  GoJekContactApp
//
//  Created by Faraz on 18/05/19.
//  Copyright © 2019 Faraz. All rights reserved.
//

import Foundation
import UIKit

class ContactsAPIHandler: APIHandler {
    
    override init() {
        
    }
    
    internal func getContacts(completion:  @escaping (ContactsListViewModel) -> Void) {
        let url = baseURL + "/contacts.json"
        
        request(url, method: .GET, parameters: nil) { (response) in
            let contactDataModel = ContactsDataModel(response)
            completion(contactDataModel)
        }
    }
    
    internal func getContactDetailsForPerson(contactURL: String, completion:  @escaping (ViewContactViewModel) -> Void) {
        request(contactURL, method: .GET, parameters: nil) { (response) in
            let contactDataModel = ContactDataModel(response)
            completion(contactDataModel)
        }
    }
    
    internal func getContactDetailsForPerson(userID: Int, completion:  @escaping (ViewContactViewModel) -> Void) {
        let url = baseURL + "/contacts/\(userID).json"
        
        request(url, method: .GET, parameters: nil) { (response) in
            let contactDataModel = ContactDataModel(response)
            completion(contactDataModel)
        }
    }
    
    internal func saveContact(params: [String:Any], completion:  @escaping (ViewContactViewModel) -> Void) {
        let url = baseURL + "/contacts.json"
        
        request(url, method: .POST, parameters: params) { (response) in
            let contactDataModel = ContactDataModel(response)
            completion(contactDataModel)
        }
    }
    
    internal func updateContact(params: [String:Any], completion:  @escaping (ViewContactViewModel) -> Void) {
        let url = baseURL + "/contacts.json"
        
        request(url, method: .PUT, parameters: params) { (response) in
            let contactDataModel = ContactDataModel(response)
            completion(contactDataModel)
        }
    }
    
    internal func getUserImage(_ url:String, completion:  @escaping (UIImage?) -> Void) {
        getData(fromURLStr: url) { (data) in
            if let imageData = data, let image = UIImage(data: imageData) {
                completion(image)
            } else {
                completion(nil)
            }
        }
    }
    
}
