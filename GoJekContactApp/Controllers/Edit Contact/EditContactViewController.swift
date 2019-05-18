//
//  EditContactViewController.swift
//  GoJekContactApp
//
//  Created by Faraz on 18/05/19.
//  Copyright © 2019 Faraz. All rights reserved.
//

import UIKit

class EditContactViewController: UIViewController {

    @IBOutlet weak var imageBackgroundView: UIView!
    @IBOutlet weak var contactImageView: UIImageView!
    
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    
    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var lastNameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var mobileLbl: UILabel!
    
    var gradientLayer: CAGradientLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
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
