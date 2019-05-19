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
    
    func getUserID(atIndex: Int) -> Int
    
    func getFullName(atIndex: Int) -> String
    
    func getUserImage(atIndex: Int, completion: @escaping (UIImage?) -> Void)
    
    func isContactMarkedFav(atIndex: Int) -> Bool
    
    func getContactURL(atIndex: Int) -> String?
    
    func getStatus() -> StatusCode
    
    func getErrorMessage() -> String
    
    func updateContact(viewModel: ContactViewModel, atIndex: Int)
    
    func addNewContact(viewModel: ContactViewModel?) -> Int?
    
}

class ContactsDataModel: AppDataModel, ContactsListViewModel {
    
    var contactsList:[ContactViewModel] = []
    
    override init(_ jsonResponse: Response) {
        super.init(jsonResponse)
        
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
    
    func getUserID(atIndex: Int) -> Int {
        let contact = contactsList[atIndex]
        return contact.id
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
    
    func updateContact(viewModel: ContactViewModel, atIndex: Int) {
        contactsList[atIndex] = viewModel
    }
    
    func addNewContact(viewModel: ContactViewModel?) -> Int? {
        guard let model = viewModel else {
            return nil
        }
        
        if let index = contactsList.index(where: { $0.firstName > model.firstName }) {
            contactsList.insert(model, at: index)
            
            return index
        } else {
            return nil
        }
    }
    
    func getStatus() -> StatusCode {
        return super.statusCode
    }
    
}

protocol ViewContactViewModel {
    
    func getUserID() -> Int
    
    func getFirstName() -> String
    
    func getLastName() -> String
    
    func getFullName() -> String
    
    func getEmail() -> String
    
    func getMobile() -> String
    
    func getUserImage(completion: @escaping (UIImage?) -> Void)
    
    func getContactURL() -> String?
    
    func isContactMarkedFav() -> Bool
    
    func getStatus() -> StatusCode
    
    func getErrorMessage() -> String
    
    func getContact() -> ContactViewModel?
    
}

class ContactDataModel: AppDataModel, ViewContactViewModel {
    
    var contact:ContactViewModel?
    
    override init(_ jsonResponse: Response) {
        super.init(jsonResponse)
        
        if let details = super.details {
            contact = Contact(withDetail: details)
        }
    }
    
    func getContact() -> ContactViewModel? {
        return contact
    }
    
    func getUserID() -> Int {
        return contact!.id
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
    
    func getContactURL() -> String? {
        return contact?.contactURLStr
    }
    
    func isContactMarkedFav() -> Bool {
        return contact?.isFavorite ?? false
    }
    
    func getErrorMessage() -> String {
        return super.errMessage ?? "Error"
    }
    
    func getStatus() -> StatusCode {
        return super.statusCode
    }
    
}

protocol ContactViewModel {
    
    var id: Int { get }
    var firstName: String { get }
    var lastName: String? { get }
    var profilePicUrlStr: String? { get }
    var userImage: UIImage? { get set }
    var isFavorite: Bool { get }
    var contactURLStr: String? { get }
    var email: String? { get }
    var mobile: String? { get }
    
}

class Contact: ContactViewModel {
    
    var id: Int
    var firstName: String
    var lastName: String?
    var profilePicUrlStr: String?
    var userImage: UIImage?
    var isFavorite: Bool
    var contactURLStr: String?
    var email: String?
    var mobile: String?
    
    internal init(withDetail detail: [String: Any]) {
        id = detail["id"] as! Int
        firstName = detail["first_name"] as! String
        lastName = detail["last_name"] as? String
        profilePicUrlStr = detail["profile_pic"] as? String
        isFavorite = detail["favorite"] as? Bool ?? false
        contactURLStr = detail["url"] as? String
        email = detail["email"] as? String
        mobile = detail["phone_number"] as? String
    }
    
//    fileprivate init(withUpdateData: Contact) {
//        firstName = withUpdateData.firstName
//        lastName = withUpdateData.lastName
//        profilePicUrlStr = withUpdateData.profilePicUrlStr
//        isFavorite = withUpdateData.isFavorite
//        contactURLStr = withUpdateData.contactURLStr
//        email = withUpdateData.email
//        mobile = withUpdateData.mobile
//    }

}
