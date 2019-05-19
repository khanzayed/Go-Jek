//
//  ContactDataModel.swift
//  GoJekContactApp
//
//  Created by Faraz on 18/05/19.
//  Copyright © 2019 Faraz. All rights reserved.
//

import Foundation
import  UIKit

protocol ContactsListViewModel {
    
    func getContactsCount() -> Int
    
    func getFullName(atIndex: Int) -> String
    
    func getUserImage(atIndex: Int, completion: @escaping (UIImage?) -> Void)
    
    func isContactMarkedFav(atIndex: Int) -> Bool
    
    func getContactURL(atIndex: Int) -> String?
    
    func getErrorMessage() -> String
}

class ContactsDataModel: AppDataModel, ContactsListViewModel {
    
    var contactsList:[Contact] = []
    
    override init(_ jsonResponse: Any?, errorMessage: String?) {
        super.init(jsonResponse, errorMessage: errorMessage)
        
        if let list = super.list {
            contactsList = list.map{ Contact(withDetail: $0) }
        }
    }
    
    func getContactsCount() -> Int {
        return contactsList.count
    }
    
    func getFullName(atIndex: Int) -> String {
        let contact = contactsList[atIndex]
        var name = contact.firstName
        if let lName = contact.lastName {
            name += " \(lName)"
        }
        
        return name
    }
    
    func getUserImage(atIndex: Int, completion: @escaping (UIImage?) -> Void) {
        if let image = contactsList[atIndex].userImage {
            completion(image)
        } else {
            if var url = contactsList[atIndex].profilePicUrlStr {
                if url.hasPrefix("/images") {
                    url = "https://gojek-contacts-app.herokuapp.com" + url
                }
                
                ContactsAPIHandler().getUserImage(url) { [weak self] (image) in
                    self?.contactsList[atIndex].userImage = image
                    completion(image)
                }
            } else {
                completion(nil)
            }
        }
    }
    
    func isContactMarkedFav(atIndex: Int) -> Bool {
        return contactsList[atIndex].isFavorite
    }
    
    func getContactURL(atIndex: Int) -> String? {
        return contactsList[atIndex].contactURLStr
    }
    
    func getErrorMessage() -> String {
        return super.errMessage ?? "Error"
    }
    
}

protocol ViewContactViewModel {
    
    func getFirstName() -> String
    
    func getLastName() -> String
    
    func getFullName() -> String
    
    func getEmail() -> String
    
    func getMobile() -> String
    
    func getUserImage(completion: @escaping (UIImage?) -> Void)
    
    func isContactMarkedFav() -> Bool
    
    func getErrorMessage() -> String
    
}

class ContactDataModel: AppDataModel, ViewContactViewModel {
    
    var contact:Contact?
    
    override init(_ jsonResponse: Any?, errorMessage: String?) {
        super.init(jsonResponse, errorMessage: errorMessage)
        
        if let details = super.details {
            contact = Contact(withDetail: details)
        }
    }
    
    func getFirstName() -> String {
        return contact?.firstName ?? ""
    }
    
    func getLastName() -> String {
        return contact?.lastName ?? ""
    }
    
    func getFullName() -> String {
        var name = contact?.firstName ?? ""
        if let lName = contact?.lastName {
            name = name + " \(lName)"
        }
        
        return name
    }
    
    func getEmail() -> String {
        return contact?.email ?? ""
    }
    
    func getMobile() -> String {
        return contact?.mobile ?? ""
    }
    
    func getUserImage(completion: @escaping (UIImage?) -> Void) {
        if let image = contact?.userImage {
            completion(image)
        } else {
            if var url = contact?.profilePicUrlStr {
                if url.hasPrefix("/images") {
                    url = "https://gojek-contacts-app.herokuapp.com" + url
                }
                
                ContactsAPIHandler().getUserImage(url) { [weak self] (image) in
                    self?.contact?.userImage = image
                    completion(image)
                }
            } else {
                completion(nil)
            }
        }
    }
    
    func isContactMarkedFav() -> Bool {
        return contact?.isFavorite ?? false
    }
    
    func getErrorMessage() -> String {
        return super.errMessage ?? "Error"
    }
    
}


class Contact {
    
    var id: Int
    var firstName: String
    var lastName: String?
    var profilePicUrlStr: String?
    var userImage: UIImage?
    var isFavorite: Bool
    var contactURLStr: String?
    var email: String?
    var mobile: String?
    
    fileprivate init(withDetail detail: [String: Any]) {
        id = detail["id"] as! Int
        firstName = detail["first_name"] as! String
        lastName = detail["last_name"] as? String
        profilePicUrlStr = detail["profile_pic"] as? String
        isFavorite = detail["favorite"] as? Bool ?? false
        contactURLStr = detail["url"] as? String
        email = detail["email"] as? String
        mobile = detail["phone_number"] as? String
    }

}
