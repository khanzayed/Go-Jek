//
//  EditContactViewController.swift
//  GoJekContactApp
//
//  Created by Faraz on 19/05/19.
//  Copyright © 2019 Faraz. All rights reserved.
//

import UIKit

class EditContactViewController: UIViewController {
    
    typealias ReloadDataOnSuccessfulSave = (ViewContactViewModel) -> Void
    var reloadData: ReloadDataOnSuccessfulSave?
    
    @IBOutlet weak var imageBackgroundView: UIView!
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    
    var gradientLayer: CAGradientLayer!
    
    var viewModel: ViewContactViewModel?
    var selectedField: UITextField!
    var keyboardHeight: CGFloat = 0
    
    var saveButton: UIBarButtonItem!
    var cancelButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        updateUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(EditContactViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(EditContactViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
        self.navigationItem.leftBarButtonItem = cancelButton
    }
    
    private func updateUI() {
        self.firstNameTextField.text = viewModel?.getFirstName() ?? ""
        self.lastNameTextField.text = viewModel?.getLastName() ?? ""
        self.emailTextField.text = viewModel?.getEmail() ?? ""
        self.mobileTextField.text = viewModel?.getMobile() ?? ""
        
        viewModel?.getUserImage { [weak self] (image) in
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
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            
            let offset = selectedField.superview!.frame.origin.y
            if (UIScreen.main.bounds.height - keyboardSize.height) < (260 + offset) {
                    self.view.frame.origin.y -= min(offset, keyboardSize.height)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc private func saveButtonTapped(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        
        let params: [String: Any] = [
            "first_name"    :    firstNameTextField.text ?? "",
            "last_name"     :    lastNameTextField.text ?? "",
            "email"         :    emailTextField.text ?? "",
            "phone_number"  :    mobileTextField.text ?? "",
            "profile_pic"   :    "/images/missing.png",
            "favorite"      :    viewModel?.isContactMarkedFav() ?? false
        ]
        
        ContactsAPIHandler().saveContact(params: params) { [weak self] (dataModel) in
            guard let strongSelf = self else {
                return
            }
            
            if dataModel.getStatus() == .SUCCESS || dataModel.getStatus() == .CREATED {
                strongSelf.reloadData?(dataModel)
                
                DispatchQueue.main.async {
                    strongSelf.navigationController?.popViewController(animated: true)
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
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        selectedField = textField
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var tag = textField.tag
        if tag == 104 { // Email field
            textField.resignFirstResponder()
            self.view.frame.origin.y = 0
            
            return true
        } else {
            tag += 1
            if let nextTextField = self.view.viewWithTag(tag) as? UITextField {
                nextTextField.becomeFirstResponder()
                
                let offset = nextTextField.superview!.frame.origin.y
                if (UIScreen.main.bounds.height - keyboardHeight) < (260 + offset) {
                    self.view.frame.origin.y = -min(offset, keyboardHeight)
                }
                
                return false
            }
        }
        textField.resignFirstResponder()
        self.view.frame.origin.y = 0
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == " " {
            return false
        }
        return true
    }
    
}
