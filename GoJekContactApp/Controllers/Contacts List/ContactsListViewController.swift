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
                if viewModel.getContactsCount() > 0{
                    DispatchQueue.main.async {
                        self.contactsTableView.reloadData()
                    }
                } else {
                    print(viewModel.getErrorMessage())
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
            
            strongSelf.contactsViewModel = dataModel
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
        if let viewModel = contactsViewModel {
            return viewModel.getContactsCount()
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell") as! ContactTableViewCell
        
        cell.nameLbl.text = contactsViewModel!.getFullName(atIndex: indexPath.row)
        cell.favImageView.isHidden = !contactsViewModel!.isContactMarkedFav(atIndex: indexPath.row)
    
        cell.userImageView.image = nil
        contactsViewModel!.getUserImage(atIndex: indexPath.row, completion: { [weak self] (image) in
            guard let _ = self else {
                return
            }
            
            DispatchQueue.main.async {
                cell.userImageView.image = image
            }
            
        })
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let contactURL = contactsViewModel?.getContactURL(atIndex: indexPath.row) {
            ContactsAPIHandler().getContactDetailsForPerson(contactURL: contactURL, completion: { [weak self] (dataModel) in
                let viewContactViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewContactViewController") as! ViewContactViewController
                viewContactViewController.contactViewModel = dataModel
                
                DispatchQueue.main.async {
                    self?.navigationController?.pushViewController(viewContactViewController, animated: true)
                }
            })
        }
    }
    
}
