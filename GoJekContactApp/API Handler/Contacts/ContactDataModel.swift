//
//  ContactDataModel.swift
//  GoJekContactApp
//
//  Created by Faraz on 18/05/19.
//  Copyright © 2019 Faraz. All rights reserved.
//

import Foundation
import  UIKit

class ContactsDataModel: AppDataModel {
    
    var contactsList:[Contact] = []
    
    override init(_ jsonResponse: Any?, errorMessage: String?) {
        super.init(jsonResponse, errorMessage: errorMessage)
        
        if let list = super.list {
            contactsList = list.map{ Contact(withDetail: $0) }
        }
    }
    
}

class ContactDataModel: AppDataModel {
    
    var contact:Contact?
    
    override init(_ jsonResponse: Any?, errorMessage: String?) {
        super.init(jsonResponse, errorMessage: errorMessage)
        
        if let details = super.details {
            contact = Contact(withDetail: details)
        }
    }
    
}


class Contact {
    
    var id: Int
    var firstName: String
    var lastName: String?
    var profilePicUrlStr: String?
    var isFavorite: Bool
    var contactURLStr: String?
    var email: String?
    
    fileprivate init(withDetail detail: [String: Any]) {
        id = detail["id"] as! Int
        firstName = detail["first_name"] as! String
        lastName = detail["last_name"] as? String
        profilePicUrlStr = detail["profile_pic"] as? String
        isFavorite = detail["favorite"] as? Bool ?? false
        contactURLStr = detail["url"] as? String
    }

}

protocol ContactCellViewModel {
    
    var id: Int { get}
    var name: String { get }
    var email: String? { get }
    var userImage: UIImage? { get }
    var isFavorite: Bool { get }
}

class ContactCellViewModelFromModel: ContactCellViewModel {
    
    var id: Int
    var name: String
    var email: String?
    var userImage: UIImage?
    var isFavorite: Bool
    fileprivate var imageURL: String?
    
    fileprivate init(withContact contact: Contact) {
        id = contact.id
        
        if let lastName = contact.lastName {
            name = contact.firstName + lastName
        } else {
            name = contact.firstName
        }
        
        isFavorite = contact.isFavorite
        if let url = contact.profilePicUrlStr, url.count > 0 {
            if url.hasPrefix("/images") {
                imageURL = "https://gojek-contacts-app.herokuapp.com" + url
            } else {
                imageURL = url
            }
        }
    }
    
}


protocol ContactsListViewModel {
    
    var contactsList: [ContactCellViewModelFromModel] { get }
    var errorMessage: String? { get }
    func getUserImage(atIndex index: Int, completion: @escaping (UIImage?) -> Void)
}

class ContactsListViewModelFromModel: ContactsListViewModel {
   
    var contactsList:[ContactCellViewModelFromModel] = []
    var errorMessage: String?
    
    init(dataModel: ContactsDataModel) {
        self.contactsList = dataModel.contactsList.map({ ContactCellViewModelFromModel(withContact: $0) })
        self.errorMessage = dataModel.errMessage
    }
    
    func getUserImage(atIndex index: Int, completion: @escaping (UIImage?) -> Void) {
        if let url = contactsList[index].imageURL {
            ContactsAPIHandler().getUserImage(url) { [weak self] (image) in
                self?.contactsList[index].userImage = image
                completion(image)
            }
        } else {
            completion(nil)
        }
    }
    
}
