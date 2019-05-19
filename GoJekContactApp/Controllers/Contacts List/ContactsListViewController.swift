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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var contactsViewModel: ContactsListViewModel? {
        didSet {
            if let viewModel = contactsViewModel {
                if viewModel.getContactsCount() > 0{
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.contactsTableView.isHidden = false
                        self.contactsTableView.reloadData()
                    }
                } else {
                    let alertVC = UIAlertController(title: "Error", message: viewModel.getErrorMessage(), preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    
                    alertVC.addAction(okAction)
                    DispatchQueue.main.async {
                        self?.navigationController?.present(alertVC, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupUI()
        getContacts()
    }
    
    private func setupUI() {
        addButton = UIBarButtonItem(title: "+", style: .done, target: self,
                                     action: #selector(ContactsListViewController.addButtonTapped(_:)))
        self.navigationItem.rightBarButtonItem = addButton
    }

    internal func getContacts() {
        contactsTableView.isHidden = true
        ContactsAPIHandler().getContacts { [weak self] (dataModel) in
            guard let strongSelf = self else {
                return
            }
            
            if dataModel.getStatus() == .SUCCESS {
                strongSelf.contactsViewModel = dataModel
            } else {
                let alertVC = UIAlertController(title: "Error", message: dataModel.getErrorMessage(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                
                alertVC.addAction(okAction)
                DispatchQueue.main.async {
                    self?.navigationController?.present(alertVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc private func addButtonTapped(_ sender: UIBarButtonItem) {
        if activityIndicator.isAnimating == false {
            let addViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditContactViewController") as! EditContactViewController
            addViewController.reloadData = { [weak self] (viewModel) in
                guard let strongSelf = self else {
                    return
                }
                
                if let newIndex = strongSelf.contactsViewModel?.addNewContact(viewModel: viewModel.getContact()) {
                    DispatchQueue.main.async {
                        strongSelf.contactsTableView.beginUpdates()
                        strongSelf.contactsTableView.insertRows(at: [IndexPath(row: newIndex, section: 0)], with: .automatic)
                        strongSelf.contactsTableView.endUpdates()
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(addViewController, animated: true)
            }
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
        
        if let userID = contactsViewModel?.getUserID(atIndex: indexPath.row) {
            ContactsAPIHandler().getContactDetailsForPerson(userID: userID) { [weak self] (dataModel) in
                if dataModel.getStatus() == .SUCCESS {
                    let viewContactViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewContactViewController") as! ViewContactViewController
                    viewContactViewController.contactViewModel = dataModel
                    viewContactViewController.atIndex = indexPath.row
                    
                    viewContactViewController.updateData = { [weak self] (index, updatedViewModel) in
                        guard let strongSelf = self, let viewModel = updatedViewModel else {
                            return
                        }
                        
                        strongSelf.contactsViewModel?.updateContact(viewModel: viewModel, atIndex: index)
                        DispatchQueue.main.async {
                            strongSelf.contactsTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self?.navigationController?.pushViewController(viewContactViewController, animated: true)
                    }
                } else {
                    let alertVC = UIAlertController(title: "Error", message: dataModel.getErrorMessage(), preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    
                    alertVC.addAction(okAction)
                    DispatchQueue.main.async {
                        self?.navigationController?.present(alertVC, animated: true, completion: nil)
                    }
                }
                
            }
        }
    }
    
}
