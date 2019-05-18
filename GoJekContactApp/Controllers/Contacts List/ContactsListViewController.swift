//
//  ViewController.swift
//  GoJekContactApp
//
//  Created by Faraz on 18/05/19.
//  Copyright © 2019 Faraz. All rights reserved.
//

import UIKit

class ContactsListViewController: UIViewController {

    @IBOutlet weak var contactsTableView: UITableView!
    
    var contactsViewModel: ContactsListViewModel? {
        didSet {
            if let viewModel = contactsViewModel {
                if viewModel.contactsList.count > 0 {
                    DispatchQueue.main.async {
                        self.contactsTableView.reloadData()
                    }
                } else {
                    print(viewModel.errorMessage ?? "")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        getContacts()
    }

    internal func getContacts() {
        ContactsAPIHandler().getContacts { [weak self] (dataModel) in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.contactsViewModel = ContactsListViewModelFromModel(dataModel: dataModel)
        }
    }
    
}

extension ContactsListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let list = contactsViewModel?.contactsList {
            return list.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell") as! ContactTableViewCell
        
        let contact = contactsViewModel!.contactsList[indexPath.row]
        cell.contactCellViewModel = contact
//        cell.userImageView.image = contact.userImage
        if contact.userImage == nil {
            contactsViewModel!.getUserImage(atIndex: indexPath.row) { (image) in
                DispatchQueue.main.async {
                    cell.userImageView.image = image
                }
            }
        } else {
            cell.userImageView.image = contact.userImage
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
