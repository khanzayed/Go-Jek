//
//  EditContactViewController.swift
//  GoJekContactApp
//
//  Created by Faraz on 18/05/19.
//  Copyright © 2019 Faraz. All rights reserved.
//

import UIKit

class ViewContactViewController: UIViewController {
    
    typealias UpdateDataInList = (Int, ContactViewModel?) -> Void
    var updateData: UpdateDataInList?
    
    @IBOutlet weak var imageBackgroundView: UIView!
    @IBOutlet weak var contactImageView: UIImageView!
    
    @IBOutlet weak var favImageView: UIImageView!
    
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    
    @IBOutlet weak var fullNameLbl: UILabel!
    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var lastNameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var mobileLbl: UILabel!
    
    var gradientLayer: CAGradientLayer!
    
    var contactViewModel: ViewContactViewModel?
    var atIndex: Int!
    
    var editButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        updateUI()
    }
    
    private func setupUI() {
        contactImageView.layer.cornerRadius = contactImageView.bounds.height / 2
        
        gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.white.cgColor,  Colors.primaryGreen.cgColor]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.1)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.8)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width,
                                     height: imageBackgroundView.frame.height)
        gradientLayer.opacity = 0.7
        
        imageBackgroundView.layer.insertSublayer(gradientLayer, at: 0)
        
        editButton = UIBarButtonItem(title: "Edit", style: .done, target: self,
                                     action: #selector(ViewContactViewController.editButtonTapped(_:)))
        self.navigationItem.rightBarButtonItem = editButton
    }
    
    private func updateUI() {
        guard let viewModel = contactViewModel else {
            return
        }
        
        self.fullNameLbl.text =  viewModel.getFullName()
        self.firstNameLbl.text = viewModel.getFirstName()
        self.lastNameLbl.text = viewModel.getLastName()
        self.emailLbl.text = viewModel.getEmail()
        self.mobileLbl.text = viewModel.getMobile()
        
        let favImage = viewModel.isContactMarkedFav() ? UIImage(named: "favourite_selected") : UIImage(named: "favourite_unselected")
        self.favImageView.image = favImage
        
        viewModel.getUserImage { [weak self] (image) in
            guard let strongSelf = self else {
                return
            }
            
            DispatchQueue.main.async {
                strongSelf.contactImageView.image = image
            }
        }
    }
    
    @objc private func editButtonTapped(_ sender: UIBarButtonItem) {
        guard let viewModel = contactViewModel else {
            return
        }
        
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditContactViewController") as! EditContactViewController
        controller.viewModel = viewModel
        controller.reloadData = { [weak self] (updatedViewModel) in
            self?.reloadData(updatedViewModel)
        }
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func messageButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func callButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func emailButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func favButtonTapped(_ sender: UIButton) {
        
    }

}

extension ViewContactViewController {
    
    internal func reloadData(_ viewModel: ViewContactViewModel) {
        self.contactViewModel = viewModel
        
        DispatchQueue.main.async {
            self.updateUI()
        }
        
        self.updateData?(atIndex, viewModel.getContact())
    }
    
}
