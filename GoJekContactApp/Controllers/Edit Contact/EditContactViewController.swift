//
//  EditContactViewController.swift
//  GoJekContactApp
//
//  Created by Faraz on 19/05/19.
//  Copyright © 2019 Faraz. All rights reserved.
//

import UIKit

class EditContactViewController: UIViewController {
    
    @IBOutlet weak var imageBackgroundView: UIView!
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    
    var gradientLayer: CAGradientLayer!
    
    var viewModel: ViewContactViewModel!
    var saveButton: UIBarButtonItem!
    var cancelButton: UIBarButtonItem!
    
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
        
        saveButton = UIBarButtonItem(title: "Save", style: .done, target: self,
                                     action: #selector(EditContactViewController.saveButtonTapped(_:)))
        self.navigationItem.rightBarButtonItem = saveButton
        
        cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self,
                                     action: #selector(EditContactViewController.cancelButtonTapped(_:)))
        self.navigationItem.backBarButtonItem = cancelButton
    }
    
    private func updateUI() {
        self.firstNameTextField.text = viewModel.getFirstName()
        self.lastNameTextField.text = viewModel.getLastName()
        self.emailTextField.text = viewModel.getEmail()
        self.mobileTextField.text = viewModel.getMobile()
        
        viewModel.getUserImage { [weak self] (image) in
            guard let strongSelf = self else {
                return
            }
            
            DispatchQueue.main.async {
                strongSelf.contactImageView.image = image
            }
        }
    }
    
    @objc private func cancelButtonTapped(_ sender: UIBarButtonItem) {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func saveButtonTapped(_ sender: UIBarButtonItem) {
        let (isValid, message) = validateData()
        if isValid {
            let params: [String: Any] = [
                "first_name"    :    firstNameTextField.text ?? "",
                "last_name"     :    lastNameTextField.text ?? "",
                "email"         :    emailTextField.text ?? "",
                "phone_number"  :    mobileTextField.text ?? "",
                "profile_pic"   :    "/images/missing.png",
                "favorite"      :    false
            ]
            ContactsAPIHandler().saveContact(params: params) { [weak self] (dataModel) in
                guard let _ = self else {
                    return
                }
                
                
            }
        } else {
            print(message)
        }
    }
    
    private func validateData() -> (Bool, String) {
        if let text = firstNameTextField.text, text.count == 0 {
            return (false, "First name cannot be blank")
        }
        
        if let text = mobileTextField.text, text.count == 0 {
            return (false, "Contact number cannot be blank")
        }
        
        return (true, "")
    }
    
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        
    }
    
}


extension EditContactViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var tag = textField.tag
        if tag == 104 { // Email field
            textField.resignFirstResponder()
            
            return true
        } else {
            tag += 1
            if let nextTextField = self.view.viewWithTag(tag) as? UITextField {
                nextTextField.becomeFirstResponder()
                
                return false
            }
        }
        textField.resignFirstResponder()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == " " {
            return false
        }
        return true
    }
    
}
